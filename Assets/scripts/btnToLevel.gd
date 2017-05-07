var current_scene

func play_pressed():
	current_scene.queue_free()
	get_tree().change_scene('res://Levels/Level1.tscn')

func play_credits():
	current_scene.queue_free()
	get_tree().change_scene('res://Levels/Credits.tscn')

func play_options():
	current_scene.queue_free()
	get_tree().change_scene('res://Levels/Options.tscn')

func quit_pressed():
	current_scene.queue_free()
	get_tree().quit();

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

	get_node("play").connect("pressed", self, "play_pressed")
	get_node("credits").connect("pressed", self, "play_credits")
	get_node("options").connect("pressed", self, "play_options")
	get_node("quit").connect("pressed", self, "quit_pressed")
