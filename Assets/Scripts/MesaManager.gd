class_name MesaManager
extends Node3D

@export var spawners : Array[Spawner]

func _ready() -> void:
	GameManager.PoolManager.mesa_manager = self
	spawn_bubbles()

func spawn_bubbles():
	for i in spawners.size():
		var newbubble = GameManager.PoolManager.bubble_prefabs[randi_range(0, GameManager.PoolManager.bubble_prefabs.size()-1)].instantiate() as Node3D
		add_child(newbubble)
		newbubble.global_position = spawners[i].global_position
		
func spawn_num_bubbles(num):
	var nums_used : Array[int]
	for i in num:
		var rand_spawner : int = -1
		while not nums_used.find(rand_spawner) and not spawners[rand_spawner].check_near():
			rand_spawner = randi_range(0, spawners.size()-1)
		nums_used.append(rand_spawner)
		var newbubble = GameManager.PoolManager.bubble_prefabs[randi_range(0, GameManager.PoolManager.bubble_prefabs.size()-1)].instantiate() as Node3D
		add_child(newbubble)
		newbubble.global_position = spawners[rand_spawner].global_position
		
