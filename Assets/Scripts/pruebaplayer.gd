class_name Player
extends Node3D

@onready var rigidbody = $RigidBody3D
@onready var palo_hit_sound = $PaloHit

var is_moving : bool = false
var is_my_turn : bool = false

var player_id : int = 0

var charging : bool = false
var charge_meter : float = 0.0
const CHARGE_MAX = 3.0 

@export var forceBar : ForceBarController

func _ready() -> void:
	GameManager.PoolManager.StopBall.connect(stop_movement)
	GameManager.PoolManager.PlayerStartTurn.connect(set_player_turn)
	player_id = GameManager.PoolManager.current_players
	GameManager.PoolManager.current_players += 1
	
func _process(delta: float) -> void:
	if charging:
		charge_meter += delta
		forceBar.bar.value = charge_meter / CHARGE_MAX
		if charge_meter > CHARGE_MAX:
			charge_meter = CHARGE_MAX
			pass
		pass
	
func _input(event):
	if not is_moving and is_my_turn:
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
	
func set_player_turn(num):
	is_my_turn = (num == player_id)
	
	forceBar.toggleState(is_my_turn)
