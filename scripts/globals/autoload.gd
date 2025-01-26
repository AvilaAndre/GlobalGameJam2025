extends Node2D

var running : bool = true
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

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
	for i in range(planets.size()):
		var alertTimer = Timer.new()
		set_planet_alert_timeout(planets[i], planets[i].alert_timeout_type.values().pick_random())
		alertTimer.timeout.connect(on_alert_timer_timeout.bind(planets[i], alertTimer))
		add_child(alertTimer)
		start_alert_timer(planets[i], alertTimer)


func _process(delta: float) -> void:
	if running:
		for planet in planets.values():
			planet.food += delta
			planet.population =  planet.food / 1

			planet.housing_lvl = min(planet.population/10, 3)

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
		var arr = []
		if (p.food_lvl != 0):
			arr.push_back(0)
		if (p.water_lvl != 0):
			arr.push_back(1)
		if (p.oxygen_lvl != 0):
			arr.push_back(2)
		#elif (p.mine_lvl != 0):
		#	arr.push_back(3)
		if(p.housing_lvl != 0):
			arr.push_back(4)
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
		#print("[" + str(p.id) + "] Alert Incoming type: " + str(alert_type))
		start_danger_timer(p, t)
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
			p.building_alert = false
		elif p.mine_alert:
			# Take out a level of mine
			p.mine_alert = false
		else:
			print("Something aint right")
		
		start_alert_timer(p, t)
	else:
		start_alert_timer(p,t)

func do_if_chance(chance: float):
	return rng.randf_range(0.0, 1.0) <= chance
	
func start_danger_timer(p: PlanetType, t: Timer):
	t.set_wait_time(10.0)
	t.one_shot = true
	t.start()
