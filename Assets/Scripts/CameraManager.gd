class_name CameraManager extends Node3D

@export var camera : Camera3D = null
@export var look_target : Node3D = null
@export var default_pos : Node3D = null

var path_speed: float = 0.05
var lerp_factor: float = 3
var following_player : bool = false
var player_node : Node3D = null

func _init():
	GameManager.PoolManager.HitBall.connect(on_player_ball_hit)
	GameManager.PoolManager.PlayerStartTurn.connect(on_player_start_turn)

func _process(delta):
	move_camera(delta)
	
func move_camera(delta):
	var target_to_move_towards : Node3D = null
	if following_player:
		target_to_move_towards = player_node
		camera.global_position = camera.global_position.lerp(target_to_move_towards.global_position, lerp_factor * delta)
		var original_rot = camera.global_rotation
		camera.look_at(look_target.global_position, Vector3.UP)	
		var dest_rot = camera.global_rotation 
		if original_rot.y < dest_rot.y:
			var aux : float = abs(abs(original_rot.y) - PI)
			original_rot.y = PI + aux
		camera.global_rotation = original_rot.lerp(dest_rot, lerp_factor * delta)
	else:
		target_to_move_towards = default_pos
		camera.global_position = camera.global_position.lerp(target_to_move_towards.global_position, lerp_factor * delta)
		camera.global_rotation = camera.global_rotation.lerp(target_to_move_towards.global_rotation, lerp_factor * delta)
	
func on_player_ball_hit():
	following_player = false

func on_player_start_turn(player_id):
	following_player = true
	look_target = GameManager.players[player_id].get_ball()
	player_node = GameManager.players[player_id].get_stick()
