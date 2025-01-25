extends Node2D

class Planet:
	var id: int
	var position: Vector2
	var water: float
	var food: float
	var oxygen: float

var running : bool = false
var rng = RandomNumberGenerator.new()

var planets: Dictionary = {
	0: newPlanet(0, 0, 0),
	2: newPlanet(2, -100.0, 200.0),
	1: newPlanet(1, -300.0, 0),
	3: newPlanet(3, 240.0, -400.0),
	4: newPlanet(4, 350.0, 100.0),
	5: newPlanet(5, -50.0, -200.0),
}

func newPlanet(id: int, x: float, y: float) -> Planet:
	var planet = Planet.new()
	planet.id = id
	planet.position = Vector2(x, y)
	planet.water = 0.0
	planet.food = 0.0
	planet.oxygen = 0.0

	return planet

func _process(_delta: float) -> void:
	if running:
		pass


