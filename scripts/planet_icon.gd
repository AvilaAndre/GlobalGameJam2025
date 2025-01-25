extends Node2D


func _ready() -> void:
	$InfoPanel.visible = false

func _process(_delta: float) -> void:
	pass


func info() -> Node2D:
	return $PlanetInfo


func _on_area_2d_mouse_exited() -> void:
	$InfoPanel.visible = false

func _on_area_2d_mouse_entered() -> void:
	$InfoPanel.visible = true
	$InfoPanel/VBoxContainer/IdLabel.text = "ID: " + str(info().id)
	$InfoPanel/VBoxContainer/FoodLabel.text = "Food: " + str(info().food)
	$InfoPanel/VBoxContainer/OxygenLabel.text = "Oxygen: " + str(info().oxygen)
	$InfoPanel/VBoxContainer/WaterLabel.text = "Water: " + str(info().water)

