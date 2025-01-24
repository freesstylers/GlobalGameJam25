extends Node3D

@export var speed : float

var rotating = false

var prev_mouse_pos
var next_mouse_pos

func _process(delta):
	if Input.is_action_just_pressed("Lclick"):
		rotating = true
		prev_mouse_pos = get_viewport().get_mouse_position()
		pass
	
	if Input.is_action_just_released("Lclick"):
		rotating = false
		pass
	
	if rotating:
		next_mouse_pos = get_viewport().get_mouse_position()
		rotate_y((next_mouse_pos.x - prev_mouse_pos.x) * speed * delta)
		rotate_z((next_mouse_pos.y - prev_mouse_pos.y) * speed * delta)
		rotate_x((next_mouse_pos.y - prev_mouse_pos.y) * speed * delta)
		prev_mouse_pos = next_mouse_pos
		pass
	pass
