extends Node

var _params = null

var loaded_scenes: Dictionary = {}

func get_scene(next_scene: String) -> PackedScene:
	if !loaded_scenes.has(next_scene):
		loaded_scenes[next_scene] = load(next_scene)
	return loaded_scenes[next_scene]

func change_scene(next_scene: String, params=null):
	_params = params
	get_tree().change_scene_to_packed(get_scene(next_scene))

func get_param(key):
	if _params != null and _params.has(key):
		return _params[key]
	return null
