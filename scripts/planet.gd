extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var id = SceneSwitcher.get_param("id")
	$PlanetInfo.id = id

	print("new Planet instantiated ", id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func info() -> Node2D:
	return $PlanetInfo
