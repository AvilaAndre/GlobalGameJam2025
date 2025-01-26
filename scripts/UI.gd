extends Node

func _ready() -> void:
	$Control/UpgradePanel.visible = false

func _process(_delta: float) -> void:
	var data = $".".get_parent().get_node("Planet").info().get_data()
	if data == null:
		return

	$Control/VBoxContainer/Label_Population.text = "Population: " + str(data.population)
	$Control/VBoxContainer/Label_Food.text = "Food: " + str(snapped(data.food, 0.1))
	$Control/VBoxContainer/Label_Oxygen.text = "Oxygen: " + str(snapped(data.oxygen, 0.1))
	$Control/VBoxContainer/Label_Water.text = "Water: " + str(snapped(data.water, 0.1))

func _on_upgrades_button_pressed():
	$Control/UpgradePanel.visible = true
	
	
func _on_close_button_pressed():
	$Control/UpgradePanel.visible = false
	$Control/AlertFoodPanel.hide()
	$Control/AlertWaterPanel.hide()
	$Control/AlertOxygenPanel.hide()
	$Control/AlertHousePanel.hide()
	$Control/AlertMinePanel.hide()
	

func _on_texture_button_pressed() -> void:
	SceneSwitcher.change_scene("res://scenes/space.tscn")
