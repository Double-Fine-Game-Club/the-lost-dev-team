extends Node2D

export var speed = 60
export (int, "Up", "Down") var initial_direction
export var keep_moving = true

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
	
func _ready():
	platform = get_node("StaticBody2D")
	area = get_node("Area2D")
	going_up = !initial_direction

	printt("initial direction", initial_direction, going_up)

	set_process(true)
