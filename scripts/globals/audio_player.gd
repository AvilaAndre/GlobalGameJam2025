extends AudioStreamPlayer

const main_menu_music = preload("res://Sound/GGJ25 Sound Ambient.wav")
const fx_button_next = preload("res://Sound/GGJ25 - UI Next.wav")
const fx_button_back = preload("res://Sound/GGJ25 - UI Back.wav")
const fx_alert_start = preload("res://Sound/GGJ25 - Alert Start.wav")
const fx_alert_res = preload("res://Sound/GGJ25 - Alert Resolved.wav")
const fx_alert_unres = preload("res://Sound/GGJ25 - Alert UnResolved.wav")
const fx_success = preload("res://Sound/GGJ25 Success.wav")
const fx_merge = preload("res://Sound/104944__glaneur-de-sons__bubble-5.wav")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_music_main_menu():
	_play_music(main_menu_music, -6.0)	
	
func play_music_level():
	#_play_music(level_music)
	pass

func play_FX(stream: AudioStream, volume = 0.0):
	var	fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()

func play_button_next():
	play_FX(fx_button_next)
	
func play_button_back():
	play_FX(fx_button_back)
	
func play_alert_start():
	play_FX(fx_alert_start)

func play_alert_res():
	play_FX(fx_alert_res, 3.0)
	
func play_alert_unres():
	play_FX(fx_alert_unres)

func play_success():
	play_FX(fx_success)
	
func play_merge():
	play_FX(fx_merge)
