class_name CameraController extends Node3D

@export var default_target : Node3D = null
@export var default_target_distance : float = 20
@export var target_distance : float = 20.0
@export var current_target : Node3D = null
@onready var camera : Camera3D = $Camera
var rotation_speed : float = 3.0
var active_play : bool = false #Ball has been shot

func _ready():
	place_in_default_position()

func _process(delta: float):
	if current_target:
		var target_bases = get_basis_from_positions(current_target.global_position + Vector3(0,10,0), current_target.global_position )
		global_transform.basis = global_transform.basis.slerp(target_bases, rotation_speed * delta)
			#look_at_target(delta)

func place_in_default_position():
	current_target = default_target
	var tween_length : float = 1.5
	var local_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	local_tween.tween_property(self, "global_position", default_target.global_position, tween_length)
	local_tween.tween_property(camera, "position:z", default_target_distance, tween_length)
	
func get_basis_from_positions(camera_pos: Vector3, target_pos: Vector3) -> Basis:
	var direction = (target_pos - camera_pos).normalized()    
	var up = Vector3(0, 1, 0)
	return Basis().looking_at(direction, up)  
