tool

extends Node2D

export var speed = 60
# TODO: Support left/right movement
export (int, "Up", "Down") var initial_direction
export var keep_moving = true setget set_keep_moving
export var width = 150 setget set_width
export var height = 300 setget set_height

var going_up
var platform
var area

func set_keep_moving(new_keep_moving):
	if new_keep_moving:
		set_process(true)
	keep_moving = new_keep_moving

func set_extents_size(new_size, width=true):
	# Shape might not have been set yet (issue #14)
	if not area:
		return
	var shape = area.get_shape(0)
	var extents = shape.get_extents()
	if width:
		extents.x = new_size
	else:
		extents.y = new_size
	shape.set_extents(extents)	

func set_width(new_width):
	set_extents_size(new_width, true)
	width = new_width

func set_height(new_height):
	set_extents_size(new_height, false)
	height = new_height

func set_direction(pos):
	# TODO: Subtract half width/height from platform to keep within extents
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
	# TODO: Unset platform variable when child is removed
	if not platform:
		for child in get_children():
			if child.is_type("PhysicsBody2D"):
				platform = child
				platform.set_pos(self.get_pos())

	if not platform:
		return

	var pos = platform.get_pos()
	set_direction(pos)
	
	# TODO: Support left/right movement
	
	if not going_up:
		pos.y += speed * delta
	else:
		pos.y -= speed * delta

	platform.set_pos(pos)
	
func _ready():
	area = get_node("Area2D")
	going_up = !initial_direction
	
	set_process(true)