extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$VBoxContainer/CurrentScore.text = "Current Population: " + str($"/root/Autoload".current_score)
	$VBoxContainer/MaxScore.text = "Your max score: " + str($"/root/Autoload".max_score)



func _on_texture_button_pressed() -> void:
	$"/root/Autoload".reset()
	AudioPlayer.play_button_back()
	SceneSwitcher.change_scene("res://scenes/main_menu.tscn")
