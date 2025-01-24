extends Node3D

func _on_rigid_body_3d_body_entered(body):
	if body.owner is Player:
		print("bola collision")
		#var player = body.owner as Player
		#player.reset_and_apply_force()
		#queue_free()
