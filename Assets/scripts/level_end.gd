var current_scene

func Quit_pressed():
		current_scene.queue_free()
		get_tree().quit();
		
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

	get_node("Quit").connect("pressed", self, "Quit_pressed")

