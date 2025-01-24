extends Node3D

func _on_rigid_body_3d_body_entered(body):
	print("bola collision")
	if body is Player:
		var player = body as Player
		player.reset_and_apply_force()
		queue_free()
