extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_main_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$"/root/Autoload".running = true
	AudioPlayer.play_button_next()
	SceneSwitcher.change_scene("res://scenes/space.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_guide_button_pressed():
	AudioPlayer.play_button_next()
	$MenuCanvas/TutorialPanel.visible = true


func _on_close_button_pressed():
	print("Close")
	AudioPlayer.play_button_back()
	$MenuCanvas/TutorialPanel.visible = false
