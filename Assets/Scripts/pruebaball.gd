class_name BaseBall
extends Node3D

func _on_rigid_body_3d_body_entered(body):
	if body.is_in_group("Player"):
		on_hit(body)

func on_hit(body):
	queue_free()
