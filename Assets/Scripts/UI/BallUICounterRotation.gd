class_name ForceBarController

extends Node3D

var rot

@export var anim : AnimationPlayer
@export var bar : ProgressBar

#func _ready() -> void:
	#rot = global_rotation


func _process(delta: float) -> void:
	pass
	#global_rotation = rot

func toggleState(state : bool) -> void:
	if state: anim.play("fade_in")
	else: anim.play("fade_out")
	pass
