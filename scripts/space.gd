extends Node2D

var planet_node = preload("res://entities/planet_icon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"/root/Autoload".create_galaxy()
	for i in $"/root/Autoload".planets.keys():
		var instance = planet_node.instantiate()
		instance.info().id = i
		$Planets.add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
