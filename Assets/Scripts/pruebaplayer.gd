class_name Player
extends Node3D

@onready var rigidbody = $RigidBody3D
@onready var palo_hit_sound = $PaloHit

@export var forceBar : ForceBarController
@onready var stick : Node3D = $BarraPivot
var rotation_speed : float = 0.5

var is_moving : bool = false
var is_my_turn : bool = false

var player_id : int = 0

var charging : bool = false
var charge_meter : float = 0.0
const CHARGE_MAX = 3.0 


func _ready() -> void:
	GameManager.PoolManager.StopBall.connect(stop_movement)
	GameManager.PoolManager.PlayerStartTurn.connect(set_player_turn)
	player_id = GameManager.PoolManager.current_players
	GameManager.players.push_back(self)
	GameManager.PoolManager.current_players += 1
	
func _process(delta: float) -> void:
	#stick.global_position = rigidbody.global_position
	if charging:
		charge_meter += delta
		forceBar.bar.value = charge_meter / CHARGE_MAX
		if charge_meter > CHARGE_MAX:
			charge_meter = CHARGE_MAX
	
func _input(event):
	if not is_moving and is_my_turn:
		#ROTATION
		var input_vector = Input.get_vector("down", "up", "right", "left")
		stick.rotate_y(input_vector.x * 0.1)
		#SHOT
		if Input.is_action_pressed("Accelerate"):
			charging = true
		if Input.is_action_just_released("Accelerate"):
			var shot_dir = -stick.global_transform.basis.x
			rigidbody.apply_force(shot_dir * 500 * charge_meter)
			palo_hit_sound.play()
			GameManager.PoolManager.HitBall.emit(charge_meter)
			is_moving = true
			charging = false
			charge_meter = 0.0
	
	
func get_stick():
	return $BarraPivot/CameraPoint
	
func get_ball():
	return rigidbody
	
func stop_movement():
	rigidbody.inertia = Vector3.ZERO
	rigidbody.linear_velocity = Vector3.ZERO
	rigidbody.angular_velocity = Vector3.ZERO
	is_moving = false
	
func apply_opposite_force():
	rigidbody.linear_velocity = -rigidbody.linear_velocity * 50
	
func apply_gravity_force(dir : Vector3):
	rigidbody.apply_force(dir * 10000)
	
func set_player_turn(num):
	is_my_turn = (num == player_id)
	forceBar.toggleState(is_my_turn)
