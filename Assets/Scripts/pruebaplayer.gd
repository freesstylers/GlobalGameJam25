class_name Player
extends Node3D

@onready var rigidbody = $RigidBody3D
@onready var palo_hit_sound = $PaloHit

var is_moving : bool = false
var is_my_turn : bool = false

var charging : bool = false
var charge_meter : float = 0.0

func _ready() -> void:
	GameManager.PoolManager.StopBall.connect(stop_movement)
	
func _process(delta: float) -> void:
	if charging:
		charge_meter += delta
		if charge_meter > 3.0:
			charge_meter = 3.0
	
func _input(event):
	if not is_moving:
		var vector = Input.get_vector("down", "up", "right", "left")
		var vector3 = Vector3(vector.x, 0, -vector.y)
		
		if Input.is_action_pressed("Accelerate"):
			charging = true
	
		if Input.is_action_just_released("Accelerate"):
			rigidbody.apply_force(vector3.normalized() * 500 * charge_meter)
			palo_hit_sound.play()
			GameManager.PoolManager.HitBall.emit()
			is_moving = true
			charging = false
			charge_meter = 0.0
	
func stop_movement():
	rigidbody.inertia = Vector3.ZERO
	rigidbody.linear_velocity = Vector3.ZERO
	rigidbody.angular_velocity = Vector3.ZERO
	is_moving = false
