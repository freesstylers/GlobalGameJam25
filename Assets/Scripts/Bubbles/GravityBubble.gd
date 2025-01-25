class_name GravityBubble
extends BaseBall

var player : Player = null

func _physics_process(delta: float) -> void:
	if player != null:
		player.apply_gravity_force((player.global_position-global_position).normalized())

func _on_gravity_zone_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		player = body.owner as Player


func _on_gravity_zone_body_exited(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		player = null
