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

const water_buttons = [
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Water_Tree/Water_Upgrade_1",
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Water_Tree/Water_Upgrade_2",
]

const wood_buttons = [
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Wood_Tree/Wood_Upgrade",
]

const stone_buttons = [
	"../UI/Control/UpgradePanel/WindowContainer/ResourceWindow/Stone_Tree/Stone_Upgrade",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var id = SceneSwitcher.get_param("id")
	if id != null:
		$PlanetInfo.id = id

	$Food.visible = false
	$Oxygen.visible = false

	setup_ui()
	update_all()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var data = info().get_data()
	if data == null: return

	$Food.visible = data.food_lvl > 0
	$Oxygen.visible = data.oxygen_lvl > 0
	
	if data.population != $population.get_child_count():
		if data.population > $population.get_child_count():
			for i in range(0, data.population - $population.get_child_count()):
				add_citizen()
		elif $population.get_child_count() >= 0:
			kill_citizen()
		update_island()
	
	check_alert()
	
func check_alert() -> void:
	$"../FoodButtonAlert".visible = $PlanetInfo.get_data().food_alert
	$"../WaterButtonAlert".visible = $PlanetInfo.get_data().water_alert
	$"../OxygenButtonAlert".visible = $PlanetInfo.get_data().oxygen_alert
	$"../HouseButtonAlert".visible = $PlanetInfo.get_data().building_alert
	# Changed after having the mine sprite
	$"../MineButtonAlert".visible = $PlanetInfo.get_data().mine_alert


func info() -> Node2D:
	return $PlanetInfo

	
func add_citizen():
	var instance = citizen_node.instantiate()
	print("Instance:", instance.possible_types)
	print("Possible:", info().get_data().dinosaur_types)
	instance.possible_types = info().get_data().dinosaur_types
	$population.add_child(instance)

	instance.position.x = Autoload.rng.randf_range(-70.0, 70.0)
	instance.position.y = Autoload.rng.randf_range(-10.0, 10.0)

func kill_citizen():
	$population.get_children()[0].die()
	$population.get_children()[0].reparent(self)


func setup_ui():
	var fields = [
		[oxygen_buttons, _on_oxygen_upgrade_pressed, PlanetType.oxygen_upgrade_cost],
		[food_buttons, _on_food_upgrade_pressed, PlanetType.food_upgrade_cost],
		[water_buttons, _on_water_upgrade_pressed, PlanetType.water_upgrade_cost],
		[wood_buttons, _on_wood_upgrade_pressed, PlanetType.wood_upgrade_cost],
		[stone_buttons, _on_stone_upgrade_pressed, PlanetType.stone_upgrade_cost],
	]

	for field in fields:
		var paths = field[0]
		var trigger = field[1]
		var costs = field[2]

		for i in range(len(paths)):
			var button: TextureButton = get_node_or_null(paths[i])
			if !button:
				printerr("setup: button not found ", paths[i])
				continue
			button.pressed.connect(trigger.bind(i+1))
			button.get_node("Label").text = str(costs[i])

func update_ui():
	var data = info().get_data()
	if data == null: return

	var fields = [
		[oxygen_buttons, data.oxygen_lvl],
		[food_buttons, data.food_lvl],
		[water_buttons, data.water_lvl],
		[wood_buttons, data.wood_lvl],
		[stone_buttons, data.stone_lvl],
	]

	for field in fields:
		var paths = field[0]
		var lvl = field[1]

		for i in range(len(paths)):
			var button: TextureButton = get_node_or_null(paths[i])
			if !button:
				printerr("update: button not found ", paths[i])
				continue
			var x = 2
			if i == lvl:
				x = 0
			elif i > lvl:
				x = 1

			button.texture_normal.region = Rect2(128*x, 0, 128, 128)


func update_island():
	var data = info().get_data()
	if data == null: return

	var three_leveled = [
		[$Oxygen, data.oxygen_lvl],
		[$Food, data.food_lvl],
		[$Water, data.water_lvl],
		[$Wood, data.wood_lvl],
		[$Housing, data.housing_lvl],
		[$Mine, data.stone_lvl],
	]

	for field in three_leveled:
		match field[1]:
			0: field[0].visible = false
			_:
				field[0].visible = true
				field[0].frame = field[1]-1


func update_all():
	update_ui()
	update_island()

func _on_oxygen_upgrade_pressed(level: int) -> void:
	var data = info().get_data()
	if data == null: return

	if data.oxygen_lvl == level-1 && data.oxygen_upgrade_cost[level-1] <= data.wood:
		data.oxygen_lvl = level
		data.wood -= data.oxygen_upgrade_cost[level-1]

	update_all()

func _on_food_upgrade_pressed(level: int) -> void:
	var data = info().get_data()
	if data == null: return

	if data.food_lvl == level-1 && data.food_upgrade_cost[level-1] <= data.wood:
		data.food_lvl = level
		data.wood -= data.food_upgrade_cost[level-1]

	update_all()

func _on_water_upgrade_pressed(level: int) -> void:
	var data = info().get_data()
	if data == null: return

	if data.water_lvl == level-1 && data.food_upgrade_cost[level-1] <= data.wood:
		data.water_lvl = level
		data.wood -= data.water_upgrade_cost[level-1]

	update_all()

func _on_wood_upgrade_pressed(level: int) -> void:
	var data = info().get_data()
	if data == null: return

	if data.wood_lvl == level-1 && data.food_upgrade_cost[level-1] <= data.wood:
		data.wood_lvl = level
		data.wood -= data.wood_upgrade_cost[level-1]

	update_all()

func _on_stone_upgrade_pressed(level: int) -> void:
	var data = info().get_data()
	if data == null: return

	if data.stone_lvl == level-1 && data.food_upgrade_cost[level-1] <= data.wood:
		data.stone_lvl = level
		data.wood -= data.stone_upgrade_cost[level-1]

	update_all()

func _on_food_button_alert_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		$"../UI/Control/AlertFoodPanel".show()


func _on_oxygen_button_alert_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		$"../UI/Control/AlertOxygenPanel".show()


func _on_house_button_alert_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		$"../UI/Control/AlertHousePanel".show()


func _on_water_button_alert_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		$"../UI/Control/AlertWaterPanel".show()


func _on_mine_button_alert_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		$"../UI/Control/AlertMinePanel".show()
