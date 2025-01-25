extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var id = SceneSwitcher.get_param("id")
	$PlanetInfo.id = id

	print("new Planet instantiated ", id)

	$Food.visible = false
	$Oxygen.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var data = info().get_data()
	if data == null: return

	$Food.visible = data.food_lvl > 0
	$Oxygen.visible = data.oxygen_lvl > 0


func info() -> Node2D:
	return $PlanetInfo
