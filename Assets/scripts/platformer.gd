extends "res://Assets/scripts/global.gd"
# By the Tutorial Doctor
# Sun Oct 18 22:22:10 EDT 2015

var current_scene
var current_level

#------------------------------------------------------------
# First, make variables for all of the things that will be in your game
var exitdoor
var artistdone
var coderdone
var body
var laptopbody
var hornbody
var player_animation
var random_jumpingsound
var player_samples
var paint_sign
var laptop_sign
var exit_door
var horn_sign
var ground
var water
var ray

const GRAVITY = 1200.0

#Angle in degrees towards either side that the player can 
#consider "floor".
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 900
const WALK_MIN_SPEED=400
const WALK_MAX_SPEED = 700
const STOP_FORCE = 1300
const JUMP_SPEED = 600
const JUMP_MAX_AIRBORNE_TIME=1

var velocity = Vector2()
var on_air_time=100
var jumping=false

var prev_jump_pressed=false
#------------------------------------------------------------

func get_random_number():
    randomize()
    return randi()%4

func _on_Laptop_Sign_Artist_body_enter(body):
	laptopbody = body.get_name()

func _on_Horn_Sign_Coder_body_enter(body):
	hornbody = body.get_name()

func _on_Exit_Door_body_enter( body ):
	exitdoor = body.get_name()

func _on_Water_body_enter( body ):
	water = body.get_name()

func _on_Ground_body_enter( body ):
	ground = body.get_name()

# The _ready() function is where we will set up everything.
#------------------------------------------------------------
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	current_level = get_tree().get_current_scene().get_filename()

	artist = get_node("Artist")
	coder = get_node("Coder")
	musician = get_node("Musician")

	player = artist
	
	set_process(true)
	
	player_samples = get_node("SamplePlayer")
	
	# The laptop sign indicates that the coder can hack.
	laptop_sign = get_node("Laptop_Sign")

	# The horn sign indicates that the musician can blow the horn.
	horn_sign = get_node("Horn_Sign")

	ray = ("Artist/RayCast2D")

# Custom functions make life easier sometimes
#------------------------------------------------------------
# This function returns true if the RayCast2D node is colliding with something, otherwise it returns false
func on_ground():
	return ray.is_colliding()

# END CUSTOM FUNCTIONS
#------------------------------------------------------------


# This is the game loop or draw() function of Godot.
#------------------------------------------------------------
func _process(delta):
	# If the RayCast2D is colliding with something (if it is on_ground()...
	#create forces
	var force = Vector2(0,GRAVITY)

	var stop = velocity.x!=0.0
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up")

	var stop=true
	
	if (walk_left):
		if (velocity.x<=WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			force.x-=WALK_FORCE			
			stop=false
		
	elif (walk_right):
		if (velocity.x>=-WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			force.x+=WALK_FORCE
			stop=false
	
	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if (vlen<0):
			vlen=0
			
		velocity.x=vlen*vsign
		
	#integrate forces to velocity
	velocity += force * delta
	
	#integrate velocity into motion and move
	var motion = velocity * delta

	#move and consume motion
	motion = player.move(motion)


	var floor_velocity=Vector2()

	if (player.is_colliding()):
		# you can check which tile was collision against with this
		# print(get_collider_metadata())

		#ran against something, is it the floor? get normal
		var n = player.get_collision_normal()

		if ( rad2deg(acos(n.dot( Vector2(0,-1)))) < FLOOR_ANGLE_TOLERANCE ):
			#if angle to the "up" vectors is < angle tolerance
			#char is on floor
			on_air_time=0
			floor_velocity=player.get_collider_velocity()
			#velocity.y=0 
			
		#But we were moving and our motion was interrupted, 
		#so try to complete the motion by "sliding"
		#by the normal
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		
		#then move again
		player.move(motion)

	if (floor_velocity!=Vector2()):
		#if floor moves, move with floor
		player.move(floor_velocity*delta)

	if (jumping and velocity.y>0):
		jumping=false
		
	if (on_air_time<JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping):	
		if(player == artist):
			random_jumpingsound = get_random_number()
			if random_jumpingsound == 1:
				player_samples.play('jump-jenni')
			if random_jumpingsound == 2:
				player_samples.play('jump2-jenni')
			else:
				player_samples.play('jump3-jenni')
		else:
			player_samples.play('grunt-kyle3wynn')

		velocity.y=-JUMP_SPEED	
		jumping=true
		
	on_air_time+=delta
	prev_jump_pressed=jump	
		
	if(laptopbody == "Artist" && Input.is_action_pressed('switch') && artistdone != true):
		player = get_node("Coder")
		ray = ("Coder/RayCast2D")
		get_node("Coder/Camera2D").make_current()
		get_node("Coder/RayCast2D").is_enabled()
		get_node("Artist").queue_free()
		artistdone = true
	if(hornbody == "Coder" && Input.is_action_pressed('switch') && coderdone != true):
		player = get_node("Musician")
		ray = ("Musician/RayCast2D")
		get_node("Musician/Camera2D").make_current()
		get_node("Musician/RayCast2D").is_enabled()
		get_node("Coder").queue_free()
		coderdone = true
	if(exitdoor == "Musician"):
		current_scene.queue_free()
		get_tree().change_scene('res://Levels/Level_end.tscn')

	#If the water is part of the player's colliding bodies...
	if(water == "Musician" || water == "Coder" || water == "Artist"):
		player_samples.play('splash-jenni')
	
	# If the ground is part of the player's colliding bodies...
	if(ground == "Musician" || ground == "Coder" || ground == "Artist"):
		# reload the current scene
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
