extends Node2D

func _ready() -> void:
	self.visible = false



func show_emote(emote: Enums.Emote, duration: float = 1.0) -> void:
	if emote not in Enums.Emote.values():
		return
	$Sprite2D.frame = emote as int
	self.visible = true

	$Timer.set_wait_time(duration)
	$Timer.start()


func _on_timer_timeout() -> void:
	self.visible = false
