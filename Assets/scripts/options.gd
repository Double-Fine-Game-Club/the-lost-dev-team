var current_scene

func GoBack_pressed():
		current_scene.queue_free()
		get_tree().change_scene('res://Levels/Menu.tscn')

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

	get_node("GoBack").connect("pressed", self, "GoBack_pressed")
