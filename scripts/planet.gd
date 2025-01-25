extends Node2D

var citizen_node: PackedScene = preload("res://entities/citizen.tscn")

const oxygen_buttons = [
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Oxygen_Tree/Oxygen_Upgrade_1",
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Oxygen_Tree/Oxygen_Upgrade_2",
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Oxygen_Tree/Oxygen_Upgrade_3",
]

const food_buttons = [
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Food_Tree/Food_Upgrade_1",
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Food_Tree/Food_Upgrade_2",
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Food_Tree/Food_Upgrade_3",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var id = SceneSwitcher.get_param("id")
	if id != null:
		$PlanetInfo.id = id

	print("new Planet instantiated ", id)

	$Food.visible = false
	$Oxygen.visible = false

	setup_ui()
	update_ui()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var data = info().get_data()
	if data == null: return

	$Food.visible = data.food_lvl > 0
	$Oxygen.visible = data.oxygen_lvl > 0
	

	print("oxygen", data.oxygen_lvl, "food", data.food_lvl)

	if data.population != $population.get_child_count():
		if data.population > $population.get_child_count():
			for i in range(0, data.population - $population.get_child_count()):
				add_citizen()
		else:
			kill_citizen()


func info() -> Node2D:
	return $PlanetInfo

func add_citizen():
	var instance = citizen_node.instantiate()
	$population.add_child(instance)

	instance.position.x = Autoload.rng.randf_range(-70.0, 70.0)
	instance.position.y = Autoload.rng.randf_range(-10.0, 10.0)

func kill_citizen():
	$population.get_children()[0].queue_free()


func setup_ui():
	for i in range(0, 3):
		var oxygen_up_button: TextureButton = get_node_or_null(oxygen_buttons[i])
		if !oxygen_up_button:
			printerr("oxygen_button not found ", i)
			continue
		oxygen_up_button.pressed.connect(_on_oxygen_upgrade_pressed.bind(i+1))

	for i in range(0, 3):
		var food_up_button: TextureButton = get_node_or_null(food_buttons[i])
		if !food_up_button:
			printerr("food_button not found ", i)
			continue
		food_up_button.pressed.connect(_on_food_upgrade_pressed.bind(i+1))

func update_ui():
	var data = info().get_data()
	if data == null: return

	for i in range(0, 3):
		var oxygen_up_button: TextureButton = get_node_or_null(oxygen_buttons[i])
		if !oxygen_up_button:
			print("oxygen_button not found ", i)
			continue

		var x = 2
		if i == data.oxygen_lvl:
			x = 0
		elif i > data.oxygen_lvl:
			x = 1

		oxygen_up_button.texture_normal.region = Rect2(128*x, 0, 128, 128)
	

	for i in range(0, 3):
		var food_up_button: TextureButton = get_node_or_null(food_buttons[i])
		if !food_up_button:
			print("food_button not found ", i)
			continue

		var x = 2
		if i == data.food_lvl:
			x = 0
		elif i > data.food_lvl:
			x = 1

		food_up_button.texture_normal.region = Rect2(128*x, 0, 128, 128)

func update_island():
	pass


func _on_oxygen_upgrade_pressed(level: int) -> void:
	var data = info().get_data()
	if data == null: return

	if data.oxygen_lvl == level-1:
		data.oxygen_lvl = level

	update_ui()

func _on_food_upgrade_pressed(level: int) -> void:
	var data = info().get_data()
	if data == null: return

	if data.food_lvl == level-1:
		data.food_lvl = level

	update_ui()
