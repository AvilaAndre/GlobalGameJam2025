class_name PlanetType


var id: int
var position: Vector2
var water: float
var food: float
var oxygen: float
var population: int

var dinosaur_types: Array

var food_lvl: int
var oxygen_lvl: int
var water_lvl: int
var wood_lvl: int
var housing_lvl: int

# Alerts
var planet_alert: bool

var building_alert : bool
var food_alert : bool
var water_alert : bool
var oxygen_alert : bool
var mine_alert : bool

var alert_prob : int
enum alert_timeout_type { XS, S, M, L, XL }
var alert_timeout_time : float

var running : bool = true

func _init(id_val: int, x: float, y: float, color: String) -> void:
	self.id = id_val
	self.position = Vector2(x, y)
	self.water = 0.0
	self.food = 0.0
	self.oxygen = 0.0
	self.population = 0
	
	self.dinosaur_types = [color]

	self.food_lvl = 0
	self.oxygen_lvl = 0
	self.water_lvl = 0
	self.wood_lvl = 0
	self.housing_lvl = 0
	
	self.planet_alert = false
	self.food_alert = false
	self.water_alert = false
	self.oxygen_alert = false
	self.mine_alert = false
	alert_timeout_time = 0
