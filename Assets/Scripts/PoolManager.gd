class_name PoolManager
extends Node

signal HitBall
signal StopBall
signal HitBubble
signal PlayerStartTurn(num)

@onready var play_timer : Timer = $PlayTimer

@export var bubble_prefabs : Array[PackedScene]

var ball_moving : bool = false

var player_turn : int = 0
var max_players : int = 2
var num_players : int = 1

var player_bubble_count : Array[int]

func _init() -> void:
	GameManager.PoolManager = self
	
func _exit_tree() -> void:
	GameManager.PoolManager = null

func _ready() -> void:
	HitBall.connect(start_play)
	HitBubble.connect(hit_bubble)
	for i in num_players:
		player_bubble_count.append(0)
	
func start_play():
	play_timer.start()
	
func hit_bubble():
	pass

func _on_play_timer_timeout() -> void:
	StopBall.emit()
	player_turn += 1
	if player_turn > num_players:
		player_turn = 0
	PlayerStartTurn.emit(player_turn)
	
func reset_game():
	player_turn = 0
	for i in player_bubble_count.size():
		player_bubble_count[i] = 0
