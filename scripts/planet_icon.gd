extends Node2D

var is_dragging = false
var drag_offset = Vector2()
var is_dead = false  # To prevent multiple triggers

func _ready() -> void:
	$InfoPanel.visible = false
	$Bubble.visible = true  # Ensure the bubble is visible initially
	$Area2D.monitoring = true  # Keep the Area2D monitoring for overlaps
	var data = info().get_data()
	print("Updating dino info for:", data.id)
	update_species_visibility(data.dinosaur_types)

func _process(_delta: float) -> void:
	var data = info().get_data()
	if data == null:
		return
	
	# Update info panel
	$InfoPanel/VBoxContainer/IdLabel.text = "ID: " + str(data.id)
	$InfoPanel/VBoxContainer/PopulationLabel.text = "Population: " + str(data.population)
	$InfoPanel/VBoxContainer/FoodLabel.text = "Food: " + str(snapped(data.food, 0.1))
	$InfoPanel/VBoxContainer/OxygenLabel.text = "Oxygen: " + str(snapped(data.oxygen, 0.1))
	$InfoPanel/VBoxContainer/WaterLabel.text = "Water: " + str(snapped(data.water, 0.1))
	$InfoPanel/VBoxContainer/MoraleLabel.text = "Morale: " + str(snapped(100 * data.morale, 1)) + "%"
	if(!data.water_alert && !data.mine_alert && !data.food_alert && !data.oxygen_alert && !data.building_alert):
		$TextureRect.hide()
	else: 
		$TextureRect.show()
		

	# Check if the planet should "die"
	if data.population <= 0 and not is_dead:
		trigger_bubble_burst()

	# Handle dragging
	if is_dragging:
		check_for_merge()


func update_species_visibility(dino_types: Array) -> void:
	print("Dinossaur Types:", dino_types)
	
	for type in dino_types:
		if type == "red":
			$Pop_Icons/red.visible = true
			print("making red visible")
		elif type == "blue":
			$Pop_Icons/blue.visible = true
			print("making blue visible")
		elif type == "yellow":
			$Pop_Icons/yellow.visible = true
			print("making yellow visible")
		elif type == "green":
			$Pop_Icons/green.visible = true
			print("making green visible")
		




func trigger_bubble_burst() -> void:
	is_dead = true  # Prevent multiple triggers
	$Bubble.play("burst")  # Play the burst animation
	$Bubble.connect("animation_finished", Callable(self, "_on_bubble_burst_finished"))
	$Area2D.visible = false  
	$InfoPanel.visible = false  

func _on_bubble_burst_finished() -> void:
	$Bubble.visible = false  # Hide the bubble after the animation
	$GameOverCanvas.visible = true
	$Pop_Icons.visible = false
	$GameOverCanvas/GameOver/VBoxContainer/Score.text = "Your reached a maximum population of " + str($"/root/Autoload".max_score)
	

# Other functions (dragging, merging, etc.) remain unchanged
func info() -> Node2D:
	return $PlanetInfo

func switch_to_planet(id: int):
	SceneSwitcher.change_scene("res://scenes/planet_focus.tscn", {"id": id})

func _on_area_2d_mouse_exited() -> void:
	$InfoPanel.visible = false

func _on_area_2d_mouse_entered() -> void:
	$InfoPanel.visible = true

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.double_click:
			if Autoload.planets.has(info().id):
				switch_to_planet(info().id)
		if event.pressed:
			is_dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			is_dragging = false
	elif event is InputEventMouseMotion and is_dragging and Input.is_action_pressed("mouse_left"):
		global_position = get_global_mouse_position() + drag_offset
		var data = info().get_data()
		if data:
			data.position = global_position

func check_for_merge() -> void:
	var area = $Area2D
	var colliding_planets = area.get_overlapping_areas()
	for planet_area in colliding_planets:
		var planet = planet_area.get_parent()
		if planet != self and planet is Node2D:
			merge_with(planet)

func merge_with(other_planet: Node2D) -> void:
	var my_data = info().get_data()
	var other_data = other_planet.info().get_data()

	my_data.food += other_data.food
	my_data.water += other_data.water
	my_data.oxygen += other_data.oxygen
	my_data.population += other_data.population
	my_data.food_lvl = max(my_data.food_lvl, other_data.food_lvl)
	my_data.oxygen_lvl = max(my_data.oxygen_lvl, other_data.oxygen_lvl)
	my_data.water_lvl = max(my_data.water_lvl, other_data.water_lvl)
	my_data.wood_lvl = max(my_data.wood_lvl, other_data.wood_lvl)
	my_data.housing_lvl = max(my_data.housing_lvl, other_data.housing_lvl)
	my_data.planet_alert = my_data.planet_alert or other_data.planet_alert
	my_data.food_alert = my_data.food_alert or other_data.food_alert
	my_data.water_alert = my_data.water_alert or other_data.water_alert
	my_data.oxygen_alert = my_data.oxygen_alert or other_data.oxygen_alert
	my_data.mine_alert = my_data.mine_alert or other_data.mine_alert

	for dinosaur in other_data.dinosaur_types:
		if not my_data.dinosaur_types.has(dinosaur):
			my_data.dinosaur_types.append(dinosaur)
			
	
	my_data.morale = (my_data.morale + other_data.morale) / 2
	other_planet.queue_free()
	Autoload.planets.erase(other_data.id)
	
	update_species_visibility(my_data.dinosaur_types)
	
	#Sound section
	AudioPlayer.play_merge()
