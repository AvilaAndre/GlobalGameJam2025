extends Node2D

var running : bool = true
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var alertTimer: Timer = Timer.new()
@onready var stats_timer: Timer = Timer.new()

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
	planets[0].food_lvl = 1
	planets[0].oxygen_lvl = 1

	rng.randomize()
	set_planet_alert_timeout(planets[0], planets[0].alert_timeout_type.values().pick_random())
	alertTimer.timeout.connect(on_alert_timer_timeout.bind(planets[0]))
	add_child(alertTimer)
	start_alert_timer(planets[0])

	stats_timer.set_wait_time(1.0)
	stats_timer.timeout.connect(on_stats_timer_timeout)
	add_child(stats_timer)
	stats_timer.start()


func _process(delta: float) -> void:
	if running:
		for planet in planets.values():

			# production
			planet.set_food(
				planet.food + planet.food_production_rates[planet.food_lvl] * (min(1, planet.population)) * planet.morale * delta)
			planet.set_oxygen(
				planet.oxygen + planet.food_production_rates[planet.oxygen_lvl] * (min(1, planet.population)) * planet.morale * delta)
			planet.set_water(
				planet.water + planet.food_production_rates[planet.water_lvl] * (min(1, planet.population)) * planet.morale * delta)

			planet.set_morale(min(1.0, planet.morale + delta * 0.005))

			# consuming
			planet.set_food(planet.food - planet.population * delta * 0.1)
			planet.set_oxygen(planet.oxygen - planet.population * delta * 0.1)
			planet.set_water(planet.water - planet.population * delta * 0.1)


			planet.housing_lvl = min(planet.population/10, 3)


func on_stats_timer_timeout() -> void:
	if running:
		for planet in planets.values():
			if planet.food == 0 || planet.water == 0 || planet.oxygen == 0:
				planet.set_population(planet.population - 1)
				planet.set_morale(planet.morale - 0.1)


func set_planet_alert_timeout(p: PlanetType, x : PlanetType.alert_timeout_type):
	match x:
		p.alert_timeout_type.XS: 
			p.alert_timeout_time = 15.0
		p.alert_timeout_type.S:
			p.alert_timeout_time = 30.0
		p.alert_timeout_type.M:
			p.alert_timeout_time = 45.0
		p.alert_timeout_type.L:
			p.alert_timeout_time = 60.0
		p.alert_timeout_type.XL:
			p.alert_timeout_time = 75.0
	
	print("[" + str(p.id) + "] Alert Time: " + str(p.alert_timeout_time))
	
func start_alert_timer(p: PlanetType) -> void:		
	alertTimer.set_wait_time(p.alert_timeout_time)
	alertTimer.one_shot = true
	alertTimer.start()
	print("[" + str(p.id) + "] Timer Started!")

func on_alert_timer_timeout(p: PlanetType):
	# On timeout check for alert
	if (randi_range(0,1) == 1):
		var alert_type = randi_range(0,4)
		match alert_type:
			0:
				p.food_alert = true
			1:
				p.water_alert = true
			2: 
				p.oxygen_alert = true
			3:
				p.building_alert = true
			4:
				p.mine_alert = true
		print("[" + str(p.id) + "] Alert Incoming type: " + str(alert_type))
			
	start_alert_timer(p)

func do_if_chance(chance: float):
	return rng.randf_range(0.0, 1.0) <= chance
