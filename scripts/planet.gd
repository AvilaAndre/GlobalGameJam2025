extends Node2D

var citizen_node: PackedScene = preload("res://entities/citizen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var id = SceneSwitcher.get_param("id")
	if id != null:
		$PlanetInfo.id = id

	print("new Planet instantiated ", id)

	$Food.visible = false
	$Oxygen.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var data = info().get_data()
	if data == null: return

	$Food.visible = data.food_lvl > 0
	$Oxygen.visible = data.oxygen_lvl > 0
	

	if data.population != $population.get_child_count():
		if data.population > $population.get_child_count():
			for i in range(0, data.population - $population.get_child_count()):
				add_citizen()
		else:
			kill_citizen()


func info() -> Node2D:
	return $PlanetInfo

func add_citizen():
	var instance = citizen_node.instantiate()
	$population.add_child(instance)

	instance.position.x = Autoload.rng.randf_range(-70.0, 70.0)
	instance.position.y = Autoload.rng.randf_range(-10.0, 10.0)

func kill_citizen():
	$population.get_children()[0].queue_free()
