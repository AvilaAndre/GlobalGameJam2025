class_name PlanetType

var id: int
var position: Vector2
var water: float
var food: float
var oxygen: float
var population: int

var running : bool = true

func _init(id_val: int, x: float, y: float) -> void:
	self.id = id_val
	self.position = Vector2(x, y)
	self.water = 0.0
	self.food = 0.0
	self.oxygen = 0.0
	self.population = 0
