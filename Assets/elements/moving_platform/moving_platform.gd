extends Node2D

export var speed = 60
export (int, "Up", "Down") var initial_direction
export var keep_moving = true
export(int) var height = 300 setget set_height

func set_height(new_height):
	printt("new height", new_height)
	height = new_height

var going_up
var platform
var area

func set_direction(pos):
	var area_pos = area.get_pos()
	var area_extents = area.get_shape(0).get_extents()
	var top = area_pos.y - area_extents.y
	var bottom = area_pos.y + area_extents.y
	
	# If top/bottom is reached, turn around or stop moving
	if (not going_up && pos.y >= bottom) || (going_up && pos.y <= top):
		going_up = !going_up
		if not keep_moving:
			set_process(false)
	
func _process(delta):
	var pos = platform.get_pos()
	set_direction(pos)
	
	if not going_up:
		pos.y += speed * delta
	else:
		pos.y -= speed * delta

	platform.set_pos(pos)

func _changed_notify(value, blarp=0):
	printt("value changed")

func _ready():
	platform = get_node("Platform")
	area = get_node("Area2D")
	
	
	
	going_up = !initial_direction

	height = 300

	set_process(true)
