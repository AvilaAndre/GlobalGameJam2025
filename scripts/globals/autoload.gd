extends Node2D

var running: bool = true
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var stats_timer: Timer = Timer.new()

var max_score: int = 0  # Player's highest score during the run
var current_score: int = 0  # Current total population score

var planets: Dictionary = {
	0: PlanetType.new(0, 0, 0, "blue"),
	2: PlanetType.new(2, -100.0, 200.0, "red"),
	1: PlanetType.new(1, -300.0, 0, "yellow"),
	3: PlanetType.new(3, 240.0, -200.0, "green"),
	4: PlanetType.new(4, 300.0, 100.0, "blue"),
	5: PlanetType.new(5, -50.0, -200.0, "red"),
}

func _ready() -> void:
	planets[0].food = 100
	planets[0].population = 5
	planets[0].food_lvl = 1
	planets[0].oxygen_lvl = 1
	
	planets[1].population = 2
	planets[1].food_lvl = 1
	planets[1].water_lvl = 1

	planets[2].population = 4
	planets[2].food_lvl = 2

	planets[3].food = 50
	planets[3].population = 1
	planets[3].oxygen_lvl = 2
	planets[3].wood_lvl = 1

	planets[4].population = 1
	planets[4].stone_lvl = 1

	planets[5].food = 90
	planets[5].population = 4
	planets[5].oxygen_lvl = 1
	planets[5].water_lvl = 2


	rng.randomize()
	for i in range(planets.size()):
		var alertTimer = Timer.new()
		set_planet_alert_timeout(planets[i], planets[i].alert_timeout_type.values().pick_random())
		alertTimer.timeout.connect(on_alert_timer_timeout.bind(planets[i], alertTimer))
		add_child(alertTimer)
		start_alert_timer(planets[i], alertTimer)

	stats_timer.set_wait_time(5.0)
	stats_timer.timeout.connect(on_stats_timer_timeout)
	add_child(stats_timer)
	stats_timer.start()


func _process(delta: float) -> void:
	if running:
		for planet in planets.values():

			# production
			planet.food_delta = planet.food_production_rates[planet.food_lvl] * (min(1, planet.population)) * planet.morale
			planet.oxygen_delta = planet.oxygen_production_rates[planet.oxygen_lvl] * (min(1, planet.population)) * planet.morale
			planet.water_delta = planet.water_production_rates[planet.water_lvl] * (min(1, planet.population)) * planet.morale
			planet.wood_delta = planet.wood_production_rates[planet.wood_lvl] * (min(1, planet.population)) * planet.morale
			planet.stone_delta = planet.stone_production_rates[planet.stone_lvl] * (min(1, planet.population)) * planet.morale


			# consuming
			planet.food_delta -= planet.population * 0.1
			planet.oxygen_delta -= planet.population * 0.1
			planet.water_delta -= planet.population * 0.1


			planet.set_morale(min(1.0, planet.morale + delta * 0.005))
			var pop_level = min(planet.population/10, 3)
			planet.housing_lvl = max(planet.housing_lvl, pop_level) #even if everyone dies the houses stay there

			planet.set_food(planet.food + planet.food_delta * delta)
			planet.set_oxygen(planet.oxygen + planet.oxygen_delta * delta)
			planet.set_water(planet.water + planet.water_delta * delta)
			planet.set_wood(planet.wood + planet.wood_delta * delta)
			planet.set_stone(planet.stone + planet.stone_delta * delta)


func on_stats_timer_timeout() -> void:
	if running:
		for planet in planets.values():
			if planet.food == 0 || planet.water == 0 || planet.oxygen == 0 || planet.morale < 0.3:
				planet.set_population(planet.population - 1)
				planet.set_morale(planet.morale - 0.05)
			elif (planet.food * 10) > planet.population && (planet.water * 5) > planet.population && planet.oxygen > planet.population && planet.morale > 0.75:
				planet.set_population(planet.population + 1)
		update_score()

func update_score() -> void:
	current_score = 0
	for planet in planets.values():
		current_score += planet.population
	max_score = max(max_score, current_score)
	print("Current Score:", current_score, "Max Score:", max_score)

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
	
	#print("[" + str(p.id) + "] Alert Time: " + str(p.alert_timeout_time))
	
func start_alert_timer(p: PlanetType, t: Timer) -> void:
	t.set_wait_time(p.alert_timeout_time)
	t.one_shot = true
	t.start()
	#print("[" + str(p.id) + "] Timer Started!")

func on_alert_timer_timeout(p: PlanetType, t: Timer):
	var coin_flip = randi_range(0,1)
	# On timeout check for alert
	if (coin_flip == 1 && !(p.food_alert || p.water_alert || p.oxygen_alert || p.building_alert || p.mine_alert)):
		var arr : Array[int] = []
		if (p.food_lvl != 0):
			arr.push_back(0)
		if (p.water_lvl != 0):
			arr.push_back(1)
		if (p.oxygen_lvl != 0):
			arr.push_back(2)
		if (p.stone_lvl != 0):
			arr.push_back(3)
		if(p.housing_lvl != 0):
			arr.push_back(4)
		if !arr.is_empty():
			var alert_type = arr.pick_random()
			match alert_type:
				0:
					p.food_alert = true
				1:
					p.water_alert = true
				2: 
					p.oxygen_alert = true
				3:
					p.mine_alert = true
				4:
					p.building_alert = true
			start_danger_timer(p, t)
			AudioPlayer.play_alert_start()
		else:
			start_alert_timer(p, t)
	elif p.food_alert || p.water_alert || p.oxygen_alert || p.building_alert || p.mine_alert:
		# If it goes here means that time is over and danger was not taken care of
		if p.food_alert:
			# Take out a level of farm
			p.food_lvl -= 1
			p.food_alert = false
		elif p.water_alert:
			# Take out a level of well
			p.water -= 1
			p.water_alert = false
		elif p.oxygen_alert:
			# Take out a level of forest
			p.oxygen_lvl -= 1
			p.oxygen_alert = false
		elif p.building_alert:
			# Take out morale
			p.set_morale(p.morale - 0.1)
			p.building_alert = false
		elif p.mine_alert:
			# Take out a level of mine
			p.stone_lvl -= 1
			p.mine_alert = false
		else:
			print("Something aint right")
		
		start_alert_timer(p, t)
		AudioPlayer.play_alert_unres()
	else:
		start_alert_timer(p,t)

func do_if_chance(chance: float):
	return rng.randf_range(0.0, 1.0) <= chance
	
func start_danger_timer(p: PlanetType, t: Timer):
	t.set_wait_time(60.0)
	t.one_shot = true
	t.start()
