class_name PoolManagement
extends Node

signal HitBall(charge)
signal PlayerWillShoot()
signal StopBall
signal NewBubble
signal HitBubble
signal PlayerStartTurn(num)

@onready var play_timer : Timer = $PlayTimer
@export var bubble_prefabs : Array[PackedScene]
@export var player_prefab : PackedScene

var ball_moving : bool = false

var is_single_player : bool = false

var player_turn : int = 0
var max_players : int = 2
var num_players : int = 1
var current_players : int = 0

var alive_bubbles : int = 0
var max_bubbles : int  = 0
var num_shots : int = 0

var player_bubble_count : Array[int]

var mesa_manager : MesaManager = null

func _init() -> void:
	GameManager.PoolManager = self
	NewBubble.connect(new_bubble)
	HitBall.connect(start_play)
	HitBubble.connect(hit_bubble)
	
func _exit_tree() -> void:
	GameManager.PoolManager = null

func _ready() -> void:
	mesa_manager.spawn_bubbles()
	mesa_manager.spawn_players()
	for i in num_players:
		player_bubble_count.append(0)
	PlayerStartTurn.emit(player_turn)
	max_bubbles = alive_bubbles
	print("Max bubbles = ", max_bubbles)
	
func start_play(charge):
	play_timer.wait_time = 10
	play_timer.start()
	if is_single_player:
		num_shots += 1
	
func new_bubble():
	alive_bubbles += 1
	
func hit_bubble():
	if is_single_player:
		hit_bubble_1player()
	else:
		hit_bubble_multiplayer()
	$AudioStreamPlayer.play()
	
func hit_bubble_1player():
	alive_bubbles -= 1
	if alive_bubbles <= 0:
		print("Tiros realizados: ", num_shots)
	
func hit_bubble_multiplayer():
	alive_bubbles -= 1
	if alive_bubbles <= 0:
		print("end")
		pass
	if alive_bubbles < max_bubbles * 0.5:
		mesa_manager.spawn_num_bubbles(alive_bubbles)
		max_bubbles = alive_bubbles

func _on_play_timer_timeout() -> void:
	StopBall.emit()
	player_turn += 1
	if player_turn > num_players:
		player_turn = 0
	PlayerStartTurn.emit(player_turn)
	print("Next turn")
	play_timer.stop()
	
func reset_game():
	player_turn = 0
	for i in player_bubble_count.size():
		player_bubble_count[i] = 0
	
