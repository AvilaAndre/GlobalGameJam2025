extends Node2D

var running : bool = true

var planets: Dictionary = {
	0: PlanetType.new(0, 0, 0),
	2: PlanetType.new(2, -100.0, 200.0),
	1: PlanetType.new(1, -300.0, 0),
	3: PlanetType.new(3, 240.0, -400.0),
	4: PlanetType.new(4, 350.0, 100.0),
	5: PlanetType.new(5, -50.0, -200.0),
}

func _ready() -> void:
	planets[0].food = 100
	planets[0].population = 5


func _process(_delta: float) -> void:
	if running:
		for i in planets.keys():
			planets[i].food += _delta
