class_name Player
extends Node3D

@onready var rigidbody = $RigidBody3D
@onready var palo_hit_sound = $PaloHit

var is_moving : bool = false

func _ready() -> void:
	GameManager.PoolManager.StopBall.connect(stop_movement)
	
func _input(event):
	if not is_moving:
		var vector = Input.get_vector("down", "up", "right", "left")
		var vector3 = Vector3(vector.x, 0, -vector.y)
	
		if Input.is_action_just_released("Accelerate"):
			rigidbody.apply_force(vector3.normalized() * 500)
			palo_hit_sound.play()
			GameManager.PoolManager.HitBall.emit()
			is_moving = true
	
func stop_movement():
	rigidbody.inertia = Vector3.ZERO
	rigidbody.linear_velocity = Vector3.ZERO
	rigidbody.angular_velocity = Vector3.ZERO
	is_moving = false
