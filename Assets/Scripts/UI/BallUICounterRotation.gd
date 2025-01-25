extends Node3D

var rot

func _ready() -> void:
	rot = global_rotation


func _process(delta: float) -> void:
	global_rotation = rot
