class_name CameraManager extends Node3D

@export var camera : Camera3D = null
@export var look_target : Node3D = null
@export var path_follow: PathFollow3D
@export var default_pos : Node3D = null

var path_speed: float = 0.05
var movement_lerp: float = 1
var rotation_lerp: float = 3
var following_path : bool = false
	
func _process(delta):
	move_camera(delta)
	
func move_camera(delta):
	var target_to_move_towards : Node3D = null
	if following_path:
		target_to_move_towards = path_follow
		path_follow.progress_ratio += (path_speed * delta)
		camera.global_position = camera.global_position.lerp(target_to_move_towards.global_position, movement_lerp * delta)
		var original_rot = camera.global_rotation
		camera.look_at(look_target.global_position, Vector3.UP)	
		var dest_rot = camera.global_rotation 
		if original_rot.y < dest_rot.y:
			var aux : float = abs(abs(original_rot.y) - PI)
			original_rot.y = PI + aux
		camera.global_rotation = original_rot.lerp(dest_rot, rotation_lerp * delta)
		print(camera.global_rotation)
	else:
		target_to_move_towards = default_pos
		if((target_to_move_towards.global_position - camera.global_position) as Vector3).length() < 0.2:
			camera.global_rotation.y= lerp(camera.global_rotation.y,3.14/2.0,1)
		camera.global_position = camera.global_position.lerp(target_to_move_towards.global_position, movement_lerp * delta)
		camera.global_rotation = camera.global_rotation.lerp(target_to_move_towards.global_rotation, rotation_lerp * delta)
	
func set_following_path(follow_path : bool):
	following_path = follow_path
