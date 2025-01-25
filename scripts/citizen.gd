extends Node2D


enum State { IDLE, WALKING }

@onready var state: State = State.IDLE
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var state_timer: Timer = Timer.new()
@onready var tween: Tween
var citizen_color = "blue"
const SPEED = 40

func _ready() -> void:
	rng.randomize()

	state_timer.timeout.connect(on_state_timer_timeout)
	add_child(state_timer)
	start_state_timer()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func start_state_timer() -> void:
	state_timer.wait_time = randf_range(1.0, 6.0)
	state_timer.set_wait_time(randf_range(1.0, 6.0))

	state_timer.one_shot = true
	state_timer.start()


func on_state_timer_timeout():
	choose_random_state()

func choose_random_state():
	change_state(rng.randi_range(0, State.size()-1) as State)

func change_state(new_state: State):
	state = new_state

	match state:
		State.WALKING:
			$AnimatedSprite2D.animation = "walk_" + citizen_color
			go_to_random_position()
		_:
			$AnimatedSprite2D.animation = "default_" + citizen_color
			start_state_timer()

func go_to_random_position():
	var path_follow: PathFollow2D = self.get_node_or_null("../../PlanetLimits/PathFollow2D")
	
	path_follow.set_progress_ratio(rng.randf_range(0.0, 1.0))
	var target_position = (path_follow.global_position - self.global_position) * rng.randf_range(0.2, 1.0) + self.global_position

	if tween:
		tween.kill()
	tween = create_tween()
	tween.connect("finished", on_tween_finished)

	$AnimatedSprite2D.flip_h = target_position.x < self.global_position.x

	var distance = self.global_position.distance_to(target_position)
	tween.tween_property(self, "global_position", target_position, distance/SPEED)

func on_tween_finished():
	change_state(State.IDLE)

