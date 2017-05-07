# Credits system adapted from Tiny Chopper Raceway 
# by Josh "Cheeseness" Bush
#
# github.com/Cheeseness/tiny-chopper-raceway

var current_scene

func GoBack_pressed():
		current_scene.queue_free()
		get_tree().change_scene('res://Levels/Menu.tscn')
		
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

	get_node("GoBack").connect("pressed", self, "GoBack_pressed")

	var file = File.new()
	file.open("res://Assets/scripts/credits.txt", File.READ)
	while(!file.eof_reached()):
		get_node("RichTextLabel").add_text(file.get_line())
		get_node("RichTextLabel").newline()
