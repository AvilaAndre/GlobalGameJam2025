class_name PlanetType


var id        : int
var position  : Vector2
var food      : float
var water     : float
var oxygen    : float
var wood      : float
var stone     : float
var population: int
var morale    : float

var dinosaur_types: Array

var food_lvl   : int
var oxygen_lvl : int
var water_lvl  : int
var wood_lvl   : int
var stone_lvl  : int
var housing_lvl: int

var water_delta : float = 0.0
var food_delta  : float = 0.0
var oxygen_delta: float = 0.0
var wood_delta  : float = 0.0
var stone_delta : float = 0.0

const food_production_rates: Array[float]   = [0.0, 1.0, 2.0, 3.0]
const oxygen_production_rates: Array[float] = [0.5, 1.0, 2.0, 3.0]
const water_production_rates: Array[float]  = [0.1, 2.0, 3.0, 3.0]
const wood_production_rates: Array[float]   = [0.0, 0.8, 2.0, 2.0]
const stone_production_rates: Array[float]  = [0.0, 0.4, 2.0, 2.0]

const food_upgrade_cost  : Array[float] = [10, 15, 20]
const oxygen_upgrade_cost: Array[float] = [10, 15, 20]
const water_upgrade_cost : Array[float] = [15, 20, 20]
const wood_upgrade_cost  : Array[float] = [20, 20, 20]
const stone_upgrade_cost : Array[float] = [20, 20, 20]

# Alerts
var planet_alert: bool

var building_alert: bool
var food_alert    : bool
var water_alert   : bool
var oxygen_alert  : bool
var mine_alert    : bool

var alert_prob : int
enum alert_timeout_type { XS, S, M, L, XL }
var alert_timeout_time : float

func _init(id_val: int, x: float, y: float, color: String) -> void:
	self.id = id_val
	self.position = Vector2(x, y)
	
	
	self.water = 10.0
	self.food = 10.0
	self.oxygen = 10.0
	self.wood = 10.0
	self.stone = 0.0
	self.population = 1
	self.morale = 0.5

	self.water_delta = 0.0
	self.food_delta = 0.0
	self.oxygen_delta = 0.0
	self.wood_delta = 0.0
	self.stone_delta = 0.0

	self.dinosaur_types = [color]

	self.food_lvl = 0
	self.oxygen_lvl = 0
	self.water_lvl = 0
	self.wood_lvl = 0
	self.stone_lvl = 0
	self.housing_lvl = 0
	
	self.planet_alert = false
	self.food_alert = false
	self.water_alert = false
	self.oxygen_alert = false
	self.mine_alert = false
	self.alert_timeout_time = 0
	self.building_alert = false

func set_food(new_value: float) -> void:
	self.food = max(0.0, new_value)

func set_oxygen(new_value: float) -> void:
	self.oxygen = max(0.0, new_value)

func set_water(new_value: float) -> void:
	self.water = max(0.0, new_value)

func set_wood(new_value: float) -> void:
	self.wood = max(0.0, new_value)

func set_stone(new_value: float) -> void:
	self.stone = max(0.0, new_value)

func set_population(new_value: int) -> void:
	self.population = clamp(new_value, 0, 100)

func set_morale(new_value: float) -> void:
	self.morale = clamp(new_value, 0.0, 1.0)
