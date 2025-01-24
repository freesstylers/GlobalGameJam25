class_name Player
extends Node3D

@onready var rigidbody = $RigidBody3D

var last_vector : Vector3

func _process(delta):
	pass
	
func _input(event):
	var vector = Input.get_vector("down", "up", "right", "left")
	var vector3 = Vector3(vector.x, 0, -vector.y)
	
	if Input.is_action_just_released("throw"):
		rigidbody.apply_force(vector3.normalized() * 500)
		last_vector = vector3.normalized()
		
func apply_opposite_force():
	var vector = -last_vector
	rigidbody.apply_force(vector * 500)


func _on_rigid_body_3d_body_entered(body):
	print("player collision")
