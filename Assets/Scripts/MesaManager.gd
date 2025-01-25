extends Node3D

@export var spawners : Array[Node3D]

func _ready() -> void:
	spawn_bubbles()

func spawn_bubbles():
	for i in spawners.size():
		var newbubble = GameManager.PoolManager.bubble_prefabs[randi_range(0, GameManager.PoolManager.bubble_prefabs.size()-1)].instantiate() as Node3D
		newbubble.global_position = spawners[i].global_position
		add_child(newbubble)
