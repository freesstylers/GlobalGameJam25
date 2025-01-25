class_name ExplodeBubble
extends BaseBall

func on_hit(body):
	var player : Player = body as Player
	player.apply_opposite_force()
	queue_free()
