extends Node2D


enum State { IDLE, WALKING, RUNNING }

@onready var state: State = State.IDLE
@onready var state_timer: Timer = Timer.new()
@onready var tween: Tween
var citizen_color = "blue"
const SPEED = 10
const RUN_SPEED = 40

func _ready() -> void:
	state_timer.timeout.connect(on_state_timer_timeout)
	add_child(state_timer)

	change_state(State.IDLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func start_state_timer() -> float:
	var wait_time: float = randf_range(1.0, 6.0)
	state_timer.set_wait_time(wait_time)

	state_timer.one_shot = true
	state_timer.start()
	return wait_time


func on_state_timer_timeout():
	choose_random_state()

func choose_random_state():
	change_state(State.values().pick_random())

func change_state(new_state: State):
	state = new_state

	match state:
		State.RUNNING:
			$AnimatedSprite2D.animation = "run_" + citizen_color
			go_to_random_position(true)
		State.WALKING:
			$AnimatedSprite2D.animation = "walk_" + citizen_color
			go_to_random_position()
		_:
			$AnimatedSprite2D.animation = "default_" + citizen_color
			var duration = start_state_timer()
			if (Autoload.do_if_chance(0.2)):
				$EmojiBubble.show_emote(Enums.Emote.values().pick_random(), duration)

func go_to_random_position(run: bool = false):
	var path_follow: PathFollow2D = self.get_node_or_null("../../PlanetLimits/PathFollow2D")
	
	path_follow.set_progress_ratio(Autoload.rng.randf_range(0.0, 1.0))
	var target_position = (path_follow.global_position - self.global_position) * Autoload.rng.randf_range(0.2, 1.0) + self.global_position

	if tween:
		tween.kill()
	tween = create_tween()
	tween.connect("finished", on_tween_finished)

	$AnimatedSprite2D.flip_h = target_position.x < self.global_position.x

	var distance = self.global_position.distance_to(target_position)
	tween.tween_property(self, "global_position", target_position, distance/(RUN_SPEED if run else SPEED))

func on_tween_finished():
	change_state(State.IDLE)

