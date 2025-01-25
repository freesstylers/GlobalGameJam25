class_name Spawner
extends Node3D

@onready var spawn_area : Area3D = $Area3D

#devuelve true si encuentra algo
func check_near() -> bool:
	var bodies : Array[Node3D] = spawn_area.get_overlapping_bodies()
	for i in bodies.size():
		if bodies[i].is_in_group("Bubbles") or bodies[i].is_in_group("Player"):
			return true
	return false
