extends Node2D
# By the Tutorial Doctor
# Sun Oct 18 22:22:10 EDT 2015

var current_scene
var current_level

#------------------------------------------------------------
# First, make variables for all of the things that will be in your game
var tutorial1_is_done
var tutorial2_is_done
var tutorial3_begin
var tutorial3_is_done
var tutorial4_begin
var tutorial4_is_done
var can_blow_on_fan
var player
var artist
var coder
var musician
var player_animation
var random_jumpingsound
var player_samples
var paint_sign
var laptop_sign
var exit_door
var horn_sign
var ray
var ray_artist
var ray_coder
var ray_musician
export var move_speed = 200
var ground
var water
var timer
var player_sprite
export var height_speed = -1000
# This variable is exported so we can change it for each level
export var next_level = ''
#------------------------------------------------------------

func get_random_number():
    randomize()
    return randi()%4

# The _ready() function is where we will set up everything.
#------------------------------------------------------------
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

	# Make sure to always enable the _process() function. This is your game loop.
	set_process(true)
	current_level = get_tree().get_current_scene().get_filename()
	# Now we set nodes to those variables we created:
	# Get the player node. It is a RigidBody node.
	# The player node should have Sprite,CollisionShape2D, and RayCast2D nodes as children
	artist = get_node("Artist")
	coder = get_node("Coder")
	musician = get_node("Musician")
		
	player = artist
	# Get the player's animation node. It is an AnimationPlayer node
	player_animation = get_node("AnimationPlayer")
	# Make the player able to monitor collision
	player.set_contact_monitor(true)
	# Also you have to make sure all collisions are reported
	player.set_max_contacts_reported(true)
	# The two steps above could be eliminated, but you need them both to do collision detection for Rigidbodies
	# Setting the mode of the player rigidbody to 2 makes it not rotate unecessarily 
	player.set_mode(2)
	# If you want the player to have sound effects, you have to store them in a sample player node
	player_samples = get_node("SamplePlayer")
	
	# The paint sign indicates that the artist can paint.
	paint_sign = get_node("Paint_Sign")
	
	# The laptop sign indicates that the coder can hack.
	laptop_sign = get_node("Laptop_Sign")

	# The horn sign indicates that the musician can blow the horn.
	horn_sign = get_node("Horn_Sign")

				# The player's Raycast2D node checks for collision in a certain direction
	ray_artist = get_node("Artist/RayCast2D")
	# So that the RayCast doesn't detect collisions with the player we need to make the player an exception.
	# Now the ray will not detect collision with the player node.
	ray_artist.add_exception(artist)

			# The player's Raycast2D node checks for collision in a certain direction
	ray_coder = get_node("Coder/RayCast2D")
	# So that the RayCast doesn't detect collisions with the player we need to make the player an exception.
	# Now the ray will not detect collision with the player node.
	ray_coder.add_exception(coder)

			# The player's Raycast2D node checks for collision in a certain direction
	ray_musician = get_node("Musician/RayCast2D")
	# So that the RayCast doesn't detect collisions with the player we need to make the player an exception.
	# Now the ray will not detect collision with the player node.
	ray_musician.add_exception(musician)
	
	ray = ray_artist
		
	# This node is a StaticBody. We will check collisions with it to restart the level.
	water = get_node("Water")
	ground = get_node("Ground")
	exit_door = get_node("Tower/Exit Door")
	
	# Timer nodes are used to do things once a certain amount of time has passed. 
	timer = get_node("Timer")
	
	# Player Sprite
	player_sprite = get_node("Artist/Sprite")

#------------------------------------------------------------


# Custom functions make life easier sometimes
#------------------------------------------------------------
# This function returns true if the RayCast2D node is colliding with something, otherwise it returns false
func on_ground():
	return ray.is_colliding()

# This function goes to the next level. You can use the connect() function to connect a signal to this function
func next_level():
	get_tree().change_scene(next_level)
# END CUSTOM FUNCTIONS
#------------------------------------------------------------


# This is the game loop or draw() function of Godot.
#------------------------------------------------------------
func _process(delta):
	# If the RayCast2D is colliding with something (if it is on_ground()...
	if on_ground():
		# And if the "up" action is pressed...
		if Input.is_action_pressed("ui_up"):
			# And if the player_animation AnimationPlayer is not playing (already)...
			if not player_animation.is_playing():
				# Then play the "squash" animation,
				#player_animation.play('squash') #not created yet
				# Set the axis_velocity on the y axis to -1000,
				player.set_axis_velocity(Vector2(0,height_speed))
				# And play the "jump" sample sound
				
				random_jumpingsound = get_random_number()
				if random_jumpingsound == 1:
					player_samples.play('jump')
				if random_jumpingsound == 2:
					player_samples.play('jump2')
				if random_jumpingsound == 3:
					player_samples.play('jump3')
	
	# Also, if the RayCast2D is colliding with something (if it is on_ground()...
	if on_ground():
		# And if the "left" action is pressed...
		if Input.is_action_pressed('ui_left'):
			# Set the axis_velocity on the x axis to minus the speed variable.
			player.set_axis_velocity(Vector2(-move_speed,0))
			#player_sprite.set('flip_h',true)
		# And if the "right" action is pressed...
		if Input.is_action_pressed('ui_right'):
			# Set the axis_velocity on the x axis the speed variable.
			player.set_axis_velocity(Vector2(move_speed,0))
			#player_sprite.set('flip_h',false)
		
	# If the artist is next to the Paint Sign
	if(paint_sign in player.get_colliding_bodies() && tutorial1_is_done != true && tutorial3_begin != true):
		get_node("Artist_Tutorial").show()
		get_tree().set_pause(true)
		if Input.is_action_pressed('enter'):
			get_tree().set_pause(false)
			get_node('Artist_Tutorial').hide()
			tutorial1_is_done=true
	if(paint_sign in player.get_colliding_bodies() && tutorial1_is_done == true && tutorial3_begin != true && Input.is_action_pressed('ctrl')):
		get_node("Platforms/Painted_Platform").show()
		get_node("Platforms/Painted_Platform/CollisionShape2D").set_trigger(false)
	
	if(paint_sign in player.get_colliding_bodies() && tutorial1_is_done == true && Input.is_action_pressed('ctrl')):
		get_node("Platforms/Painted_Platform").show()
		get_node("Platforms/Painted_Platform/CollisionShape2D").set_trigger(false)

	if(laptop_sign in player.get_colliding_bodies() && tutorial2_is_done != true && tutorial3_begin != true):
		get_node("Coder_Tutorial").show()
		get_tree().set_pause(true)
		if Input.is_action_pressed('enter'):
			get_tree().set_pause(false)
			get_node('Coder_Tutorial').hide()
			tutorial2_is_done=true
	
	if(laptop_sign in player.get_colliding_bodies() && player == artist && tutorial2_is_done == true  && tutorial3_begin != true && Input.is_action_pressed('switch')):

		player = coder

		artist.queue_free()
		player = coder
		player.set_contact_monitor(true)
		player.set_max_contacts_reported(true)
		player.set_mode(2)
		
		ray = ray_coder
		player_sprite = get_node("Coder/Sprite")
		get_node("Coder/CollisionShape2D").set_trigger(false)
		tutorial3_begin = true

	if(laptop_sign in player.get_colliding_bodies() && tutorial3_begin == true):
		get_node("Coder_Tutorial2").show()
		get_tree().set_pause(true)
		if Input.is_action_pressed('enter'):
			get_tree().set_pause(false)
			get_node('Coder_Tutorial2').hide()
			tutorial3_begin=false
			tutorial3_is_done=true

	if(laptop_sign in player.get_colliding_bodies() && tutorial3_is_done == true ):
		if(laptop_sign in player.get_colliding_bodies() && tutorial3_is_done == true && Input.is_action_pressed('ctrl')):
			get_node("Tower/closed_elevator").hide()
			get_node("Tower/CollisionShape2D").set_trigger(true)
			get_node("Moving platform").show()
			tutorial3_is_done = false

	if(horn_sign in player.get_colliding_bodies() && tutorial4_begin != true && tutorial4_is_done != true):
		get_node("Musician_Tutorial").show()
		get_tree().set_pause(true)
		if Input.is_action_pressed('enter'):
			get_tree().set_pause(false)
			get_node('Musician_Tutorial').hide()
			tutorial4_begin=true

	if(horn_sign in player.get_colliding_bodies() && player == coder && tutorial4_begin == true && can_blow_on_fan != true && Input.is_action_pressed('switch')):

		player = musician

		coder.queue_free()
		player = musician
		player.set_contact_monitor(true)
		player.set_max_contacts_reported(true)
		player.set_mode(2)
		
		ray = ray_musician
		player_sprite = get_node("Musician/Sprite")
		get_node("Musician/CollisionShape2D").set_trigger(false)
		tutorial4_is_done = true
		tutorial4_begin = false
		
	if(horn_sign in player.get_colliding_bodies() && tutorial4_is_done == true):
		get_node("Musician_Tutorial2").show()
		get_tree().set_pause(true)
		if Input.is_action_pressed('enter'):
			get_tree().set_pause(false)
			get_node('Musician_Tutorial2').hide()
			tutorial4_is_done=false
			can_blow_on_fan=true

	if(horn_sign in player.get_colliding_bodies() && can_blow_on_fan == true ):
		if(horn_sign in player.get_colliding_bodies() && can_blow_on_fan == true && Input.is_action_pressed('ctrl')):
			get_node("Tower/lower_elevator").hide()
			get_node("Tower/CollisionShape2D2").set_trigger(true)
			get_node("Moving platform2").show()
			can_blow_on_fan = false

	if(exit_door in player.get_colliding_bodies()):
		current_scene.queue_free()
		get_tree().quit();

	#If the water is part of the player's colliding bodies...
	if water in player.get_colliding_bodies():
		player_samples.play('splash')
	
	# If the ground is part of the player's colliding bodies...
	if ground in player.get_colliding_bodies():
		# reload the current scene
		player_samples.play('jump')
		get_tree().reload_current_scene()
	
	# If the "esc" or "Q" buttons are pressed...
	if Input.is_key_pressed(16777217) or Input.is_key_pressed(81): 
	#16777217 is the scancode for the escape key under @GlobalScope in the API
		# Quit the game
		get_tree().quit()
	# If the "R" key is pressed... 
	if Input.is_key_pressed(82):
	#82 is the scancode for the 'R' key under @GlobalScope in the API
		# Reload the scene
		get_tree().reload_current_scene()
		
			
# AND THAT IS ALL YOU NEED FOR A PLATFORMER BASE GAME!!!

# Duplicate this level and move the platforms around and you have a new level. 
# Be sure to change the Next Level property we exported for each level.