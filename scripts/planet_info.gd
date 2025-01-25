extends Node2D

var id: int = -1
var food: int = 0
var oxygen: int = 0
var water: int = 0

func with_data(food_val: int, oxygen_val: int, water_val: int):
	food = food_val
	oxygen = oxygen_val
	water = water_val

func get_data():
	if !$"/root/Autoload".planets.has(self.id):
		return

	var data = $"/root/Autoload".planets[self.id] 

	self.with_data(data.food, data.oxygen, data.water)

func _ready() -> void:
	get_data()


func _process(_delta: float) -> void:
	get_data()
