extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func show_window(window_name: String):
	for child in $WindowContainer.get_children():
		child.visible = (child.name == window_name)


func _on_resource_tab_button_pressed():
	show_window("ResourceWindow")

func _on_event_tab_button_pressed():
	show_window("EventWindow")

func _on_overview_tab_button_pressed():
	show_window("OverviewWindow")
