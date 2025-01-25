extends Node2D


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


func info() -> Node2D:
	return $PlanetInfo

func switch_to_planet():
	pass

func _on_area_2d_mouse_exited() -> void:
	$InfoPanel.visible = false

func _on_area_2d_mouse_entered() -> void:
	$InfoPanel.visible = true

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.double_click:
			switch_to_planet()



