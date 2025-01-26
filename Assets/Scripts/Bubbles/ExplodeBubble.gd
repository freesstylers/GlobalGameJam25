class_name ExplodeBubble
extends Bubble

func on_hit(body):
	var player : Player = body.owner as Player
	player.apply_opposite_force()
	GameManager.PoolManager.HitBubble.emit()
	on_death()
