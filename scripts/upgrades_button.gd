extends Node


func _on_upgrades_button_pressed():
	$UpgradePanel.visible = true
	
	
func _on_close_button_pressed():
	$UpgradePanel.visible = false
