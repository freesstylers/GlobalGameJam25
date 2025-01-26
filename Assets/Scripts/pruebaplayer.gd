class_name Player
extends Node3D

@export var forceBar : ForceBarController
@onready var rigidbody = $RigidBody3D
@onready var palo_hit_sound = $PaloHit
@onready var stick : Node3D = $BarraPivot
@onready var stick_model : Node3D = $BarraPivot/Taco

#Particles
@onready var hit_particles : GPUParticles3D = $RigidBody3D/RotParticulas/HitParticles
@onready var particles_point : Node3D = $RigidBody3D/RotParticulas

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
	GameManager.PoolManager.scores_per_turn.push_back([])
	
func _process(delta: float) -> void:
	if charging:
		charge_meter += delta
		forceBar.bar.value = charge_meter / CHARGE_MAX
		if charge_meter > CHARGE_MAX:
			charge_meter = CHARGE_MAX
	
func _input(event):
	if not is_moving and is_my_turn:
		#ROTATION
		var input_vector = Input.get_vector("left", "right", "right", "left")
		stick.rotate_y(input_vector.x * 0.05)
		#SHOT
		if Input.is_action_pressed("Accelerate"):
			charging = true
		if Input.is_action_just_released("Accelerate"):
			is_moving = true
			GameManager.PoolManager.PlayerWillShoot.emit()
			forceBar.toggleState(false)
			var shot_dir = -stick.global_transform.basis.x
			var displacement : int = 3
			var original_pos = stick_model.position
			var local_tween = create_tween()
			local_tween.tween_property(stick_model, "position:x", original_pos.x + displacement, 1.5).set_delay(0.5)
			local_tween.tween_property(stick_model, "position:x", original_pos.x, 0.3 - (charge_meter/3 * 0.2))
			local_tween.tween_callback(func():
				GameManager.PoolManager.HitBall.emit(charge_meter)
				particles_point.rotation = stick.rotation
				hit_particles.emitting = true
				palo_hit_sound.play()
				charging = false
				rigidbody.apply_force(shot_dir * 500 * charge_meter)
				charge_meter = 0.0
				stick.visible = false
				)
	
func get_stick():
	return $BarraPivot/CameraPoint
func get_ball():
	return rigidbody

func stop_movement():
	var tween_time : float = 1.5
	var local_tween = create_tween().set_parallel(true)
	local_tween.tween_property(rigidbody, "inertia", Vector3.ZERO, tween_time)
	local_tween.tween_property(rigidbody, "linear_velocity", Vector3.ZERO, tween_time)
	local_tween.tween_property(rigidbody, "angular_velocity", Vector3.ZERO, tween_time)
	local_tween.chain().tween_callback(func():
		is_moving = false)
	#rigidbody.inertia = Vector3.ZERO
	#rigidbody.linear_velocity = Vector3.ZERO
	#rigidbody.angular_velocity = Vector3.ZERO
	#is_moving = false
	
func apply_opposite_force():
	rigidbody.linear_velocity *= 10
	
func apply_gravity_force(dir : Vector3):
	rigidbody.apply_force(-dir * 10)
	
func set_player_turn(num):
	is_my_turn = (num == player_id)
	
	if is_my_turn:
		stick.visible = true
		forceBar.toggleState(true)
		stick.global_position = rigidbody.global_position 
		forceBar.bar.value = 0	
