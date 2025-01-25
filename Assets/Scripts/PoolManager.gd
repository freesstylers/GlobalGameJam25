class_name PoolManager
extends Node

signal HitBall
signal StopBall

@onready var play_timer : Timer = $PlayTimer

var ball_moving : bool = false

func _init() -> void:
	GameManager.PoolManager = self
	
func _exit_tree() -> void:
	GameManager.PoolManager = null

func _ready() -> void:
	HitBall.connect(start_play)
	
func start_play():
	ball_moving = true
	play_timer.start()

func _on_play_timer_timeout() -> void:
	ball_moving = false
	StopBall.emit()
