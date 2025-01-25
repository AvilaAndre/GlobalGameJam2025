extends Node2D

var is_dragging = false
var drag_offset = Vector2()

func _ready() -> void:
	$InfoPanel.visible = false

func _process(_delta: float) -> void:
	var data = info().get_data()
	if data == null:
		return
	$InfoPanel/VBoxContainer/IdLabel.text = "ID: " + str(data.id)
	$InfoPanel/VBoxContainer/PopulationLabel.text = "Population: " + str(data.population)
	$InfoPanel/VBoxContainer/FoodLabel.text = "Food: " + str(snapped(data.food, 0.1))
	$InfoPanel/VBoxContainer/OxygenLabel.text = "Oxygen: " + str(snapped(data.oxygen, 0.1))
	$InfoPanel/VBoxContainer/WaterLabel.text = "Water: " + str(snapped(data.water, 0.1))
	$InfoPanel/VBoxContainer/MoraleLabel.text = "Morale: " + str(snapped(100 * data.morale, 1)) + "%"
	if(!data.water_alert && !data.mine_alert && !data.food_alert && !data.oxygen_alert):
		$TextureRect.hide()
	else: 
		$TextureRect.show()
	if is_dragging:
		check_for_merge()


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
			# Start dragging
			is_dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			# Stop dragging
			is_dragging = false
			# Handle drop/merge logic

	elif event is InputEventMouseMotion and is_dragging:
		# Update position while dragging
		global_position = get_global_mouse_position() + drag_offset
		
func check_for_merge() -> void:
	# Check if the planet overlaps with another planet
	var area = $Area2D
	var colliding_planets = area.get_overlapping_areas()
	print("Colliding with", colliding_planets)
	for planet_area in colliding_planets:
		print("Planet area:", planet_area)
		var planet = planet_area.get_parent()
		print("Planet:", planet)
		if planet != self and planet is Node2D:  # Ensure it's a valid planet
			print("Merging with planet: ", planet.info().id)
			merge_with(planet)

func merge_with(other_planet: Node2D) -> void:
	# Get data from both planets
	var my_data = info().get_data()
	var other_data = other_planet.info().get_data()

	print("Merging Planet ID: ", my_data.id, " with Planet ID: ", other_data.id)
	print("My data: ", my_data)
	print("Other data: ", other_data)
	
	# Sum of resources
	my_data.food += other_data.food
	my_data.water += other_data.water
	my_data.oxygen += other_data.oxygen
	my_data.population += other_data.population

	# Set the maximum levels of each resource
	my_data.food_lvl = max(my_data.food_lvl, other_data.food_lvl)
	my_data.oxygen_lvl = max(my_data.oxygen_lvl, other_data.oxygen_lvl)
	my_data.water_lvl = max(my_data.water_lvl, other_data.water_lvl)
	my_data.wood_lvl = max(my_data.wood_lvl, other_data.wood_lvl)
	my_data.housing_lvl = max(my_data.housing_lvl, other_data.housing_lvl)
	
	# Merge alerts: if either planet has the alert, set it to true
	my_data.planet_alert = my_data.planet_alert or other_data.planet_alert
	my_data.food_alert = my_data.food_alert or other_data.food_alert
	my_data.water_alert = my_data.water_alert or other_data.water_alert
	my_data.oxygen_alert = my_data.oxygen_alert or other_data.oxygen_alert
	my_data.mine_alert = my_data.mine_alert or other_data.mine_alert
	
	for dinosaur in other_data.dinosaur_types:
		if not my_data.dinosaur_types.has(dinosaur):
			my_data.dinosaur_types.append(dinosaur)
	
	other_planet.queue_free()
	Autoload.planets.erase(other_data.id)
	
	
	# Additional debug to show the final merged result
	print("Merged planet data: ", my_data)
