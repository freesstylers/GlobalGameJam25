class_name CameraManager extends Node3D

@export var camera : Camera3D = null
@export var look_target : Node3D = null
@export var default_pos : Node3D = null
@export var lerp_factor: float = 3
@export var following_player : bool = false
@export var player_node : Node3D = null

var path_speed: float = 0.05

func _init():
	if !GameManager.PoolManager:
		return
	GameManager.PoolManager.PlayerWillShoot.connect(show_table_from_the_top)
	GameManager.PoolManager.PlayerStartTurn.connect(on_player_start_turn)
	GameManager.PoolManager.GameEnded.connect(on_game_ended)

func _process(delta):
	move_camera(delta)
	
func move_camera(delta):
	var target_to_move_towards : Node3D = null
	#PLAYER CONTROL
	if following_player and player_node:
		target_to_move_towards = player_node
		camera.global_position = camera.global_position.lerp(target_to_move_towards.global_position, lerp_factor * delta)
		
		var original_rot = camera.global_rotation
		camera.look_at(look_target.global_position, Vector3.UP)	
		var dest_rot = camera.global_rotation 
		#MATH MAGIC
		if sign(original_rot.y) != sign(dest_rot.y):
			if not (abs(original_rot.y) < PI/2 or abs(dest_rot.y) < PI/2):
				if sign(original_rot.y) == 1:
					var test = PI - original_rot.y
					original_rot.y = -PI - test
				else:
					var test = -PI - original_rot.y
					original_rot.y = PI - test
		camera.global_rotation = original_rot.lerp(dest_rot, lerp_factor * delta)
	#TOP VISION
	else:
		target_to_move_towards = default_pos
		camera.global_position = camera.global_position.lerp(target_to_move_towards.global_position, lerp_factor * delta)
##
		var original_rot = camera.global_rotation
		var dest_rot = target_to_move_towards.global_rotation 
		#MATH MAGIC
		if sign(original_rot.y) != sign(dest_rot.y):
			if not (abs(original_rot.y) < PI/2 or abs(dest_rot.y) < PI/2):
				if sign(original_rot.y) == 1:
					var test = PI - original_rot.y
					original_rot.y = -PI - test
				else:
					var test = -PI - original_rot.y
					original_rot.y = PI - test
		camera.global_rotation = original_rot.lerp(dest_rot, lerp_factor * delta)
	
func show_table_from_the_top():
	following_player = false

func on_player_start_turn(player_id):
	following_player = true
	look_target = GameManager.players[player_id].get_ball()
	player_node = GameManager.players[player_id].get_stick()

func on_game_ended():
	following_player = false
	player_node = null
	
