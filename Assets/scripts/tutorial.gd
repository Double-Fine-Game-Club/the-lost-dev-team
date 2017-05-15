extends "res://Assets/scripts/global.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var paintbody
var laptopbody
var hornbody
var tutorial1_is_done
var tutorial2_is_done
var tutorial3_begin
var tutorial3_is_done
var tutorial4_begin
var tutorial4_is_done
var can_blow_on_fan
var paint_sign
var laptop_sign
var horn_sign
var player_samples
var coderdone

func _on_Paint_Sign_body_enter(body):
	paintbody = body.get_name()

func _on_Laptop_Sign_body_enter(body):
	laptopbody = body.get_name()

func _on_Horn_Sign_body_enter(body):
	hornbody = body.get_name()

func _ready():
	set_process(true)
	artist = get_node("../Artist")
	coder = get_node("../Coder")
	musician = get_node("../Musician")
	laptop_sign = get_node("Laptop_Sign")
	horn_sign = get_node("Horn_Sign")
	horn_sign = get_node("Paint_Sign")
	player_samples = get_node("../SamplePlayer")

func _process(delta):
	#Artist Tutorial
	if(paintbody == "Artist" && tutorial1_is_done != true):
		get_node("Artist_Tutorial").show()
		get_tree().set_pause(true)
	if Input.is_action_pressed('enter'):
		get_tree().set_pause(false)
		get_node('Artist_Tutorial').hide()
		tutorial1_is_done=true
	if(paintbody == "Artist" && Input.is_action_pressed('ctrl')):
		player_samples.play('paint-kyle3wynn')
		get_node("../Platforms/Painted_Platform").show()
		get_node("../Platforms/Painted_Platform/CollisionShape2D").set_trigger(false)
	if(laptopbody == "Artist" && tutorial2_is_done != true):
		get_node("Coder_Tutorial").show()
		get_tree().set_pause(true)
		tutorial2_is_done=true
	if(laptopbody == "Artist" && tutorial2_is_done == true):
		if Input.is_action_pressed('enter'):
			get_tree().set_pause(false)
			get_node('Coder_Tutorial').hide()
	#Coder Tutorial
	if(laptopbody == "Coder" && tutorial3_begin != true):
		get_node("Coder_Tutorial2").show()
		get_tree().set_pause(true)
		if Input.is_action_pressed('enter'):
			get_tree().set_pause(false)
			get_node('Coder_Tutorial2').hide()
			tutorial3_begin = true
	if(laptopbody == "Coder" && Input.is_action_pressed('ctrl')):
		player_samples.play('code-kyle3wynn')
		get_node("../Tower/closed_elevator").hide()
		get_node("../Moving platform").show()
		get_node("../Tower/CollisionShape2D").set_trigger(true)
	if(hornbody == "Coder" && tutorial3_is_done != true):
		get_node("Musician_Tutorial").show()
		get_tree().set_pause(true)
		tutorial3_is_done=true
	if(hornbody == "Coder" && Input.is_action_pressed('enter')):
		get_tree().set_pause(false)
		get_node('Musician_Tutorial').hide()

	#Musician Tutorial
	if(hornbody == "Musician" && tutorial4_begin != true):
		get_node("Musician_Tutorial2").show()
		get_tree().set_pause(true)
		if Input.is_action_pressed('enter'):
			get_tree().set_pause(false)
			get_node('Musician_Tutorial2').hide()
			tutorial4_begin = true
	if(hornbody == "Musician" && Input.is_action_pressed('ctrl')):
		player_samples.play('horn-kyle3wynn')
		get_node("../Tower/lower_elevator").hide()
		get_node("../Moving platform2").show()
		get_node("../Tower/CollisionShape2D2").set_trigger(true)
