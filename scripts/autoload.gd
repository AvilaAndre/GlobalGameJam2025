extends Node2D


class Planet:
	var id: int
	var x: float
	var y: float
	var water: float
	var food: float
	var oxygen: float

var created : bool = false
var running : bool = false
var rng = RandomNumberGenerator.new()

var planets: Dictionary = {}

func create_galaxy() -> void:
	if created:
		return
	else:
		created = true

	for i in range(0, 8):
		var planet = Planet.new()
		planet.id = i
		planet.x = rng.randf_range(-100.0, 100.0)
		planet.y = rng.randf_range(-100.0, 100.0)
		planet.water = 0.0
		planet.food = 0.0
		planet.oxygen = 0.0

		planets[i] = planet

func _process(_delta: float) -> void:
	if running:
		pass


