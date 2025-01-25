class_name PlanetType


var id: int
var position: Vector2
var water: float
var food: float
var oxygen: float
var population: int
var morale: float

var dinosaur_types: Array

var food_lvl: int
var oxygen_lvl: int
var water_lvl: int
var wood_lvl: int
var housing_lvl: int

const food_production_rates: Array[float] = [0.0, 1.0, 2.0, 3.0]
const oxygen_production_rates: Array[float] = [0.0, 1.0, 2.0, 3.0]
const water_production_rates: Array[float] = [0.0, 1.0, 2.0, 3.0]
const wood_production_rates: Array[float] = [0.0, 1.0, 2.0, 3.0]

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
	
	
	self.water = 10.0
	self.food = 10.0
	self.oxygen = 10.0
	self.population = 1
	self.morale = 0.5

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
	self.alert_timeout_time = 0


func set_food(new_value: float) -> void:
	self.food = max(0.0, new_value)

func set_oxygen(new_value: float) -> void:
	self.oxygen = max(0.0, new_value)

func set_water(new_value: float) -> void:
	self.water = max(0.0, new_value)

func set_population(new_value: int) -> void:
	self.population = clamp(new_value, 0, 100)

func set_morale(new_value: float) -> void:
	self.morale = clamp(new_value, 0.0, 1.0)
