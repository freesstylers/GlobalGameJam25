extends Node3D

@export var speed : float

var rotating = false



func _input(event):

	if event is InputEventMouseButton:
		if event.is_pressed():
			rotating = true
			pass

		if event.is_released():
			rotating = false

	if event is InputEventMouseMotion and rotating:
		var delta = get_process_delta_time()
		var rel = event.relative

		$Player.rotate_y(rel.x * .7 * delta)
		$Player.rotate_z(rel.y * .7 * delta)
