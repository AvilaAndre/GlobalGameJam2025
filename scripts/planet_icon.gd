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
	$InfoPanel/VBoxContainer/WaterLabel.text = "Water: " + str(snapped(data.water, 1))
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
	print("Merged with planet ID: ", other_planet.info().id)
