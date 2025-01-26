class_name PoolManagement
extends Node

signal PlayerStartTurn(num)
signal PlayerWillShoot()
signal HitBall(charge)
signal StopBall
signal NewBubble
signal HitBubble
signal GameEnded

@export var table_prefabs : Array[PackedScene]
@export var bubble_prefabs : Array[PackedScene]
@export var player_prefab : PackedScene
@onready var play_timer : Timer = $PlayTimer
@onready var scoreBoard : ScoreBoardManager = $ParTable

var ball_moving : bool = false

var player_turn : int = 0
var score_this_turn : int = 0
var scores_per_turn : Array = []
var total_scores : Array = []

var max_players : int = 2
var current_players : int = 0

var alive_bubbles : int = 0
var max_bubbles : int  = 0
var num_turns : int = 0
var num_restocks : int = 3

var mesa_manager : MesaManager = null

func _init() -> void:
	GameManager.PoolManager = self
	NewBubble.connect(new_bubble)
	HitBall.connect(start_play)
	HitBubble.connect(hit_bubble)
	
func _exit_tree() -> void:
	GameManager.PoolManager = null

func _ready() -> void:
	scoreBoard.Fade(0,0) #Hide the scoreboard
	mesa_manager = table_prefabs[randi()%table_prefabs.size()].instantiate()
	add_child(mesa_manager)
	mesa_manager.scale = Vector3(1.5,1.5,1.5)
	mesa_manager.spawn_bubbles()
	mesa_manager.spawn_players()
	PlayerStartTurn.emit(player_turn)
	max_bubbles = alive_bubbles
	score_this_turn = 0
	scores_per_turn.push_back([])
	scores_per_turn.push_back([])
	total_scores.push_back(0)
	total_scores.push_back(0)
	print("Max bubbles = ", max_bubbles)
	
func start_play(charge):
	play_timer.wait_time = 10
	play_timer.start()
	if GameManager.num_players_in_game == 1:
		num_turns += 1
	
func new_bubble():
	alive_bubbles += 1
	
func hit_bubble():
	score_this_turn += 1
	if GameManager.num_players_in_game == 1:
		hit_bubble_1player()
	else:
		hit_bubble_multiplayer()
	$AudioStreamPlayer.play()
	
func hit_bubble_1player():
	alive_bubbles -= 1
	if alive_bubbles <= 0:
		scoreBoard.Fill(num_turns, scores_per_turn[0],total_scores[0], GameManager.num_players_in_game > 1, scores_per_turn[1],total_scores[1])
	else:
		pass
		#mesa_manager.spawn_num_bubbles(alive_bubbles)
		#max_bubbles = alive_bubbles
		#num_restocks -= 1
	
func hit_bubble_multiplayer():
	alive_bubbles -= 1
	if alive_bubbles <= 0:
		GameEnded.emit()
		scoreBoard.Fill(num_turns, scores_per_turn[0],total_scores[0], GameManager.num_players_in_game > 1, scores_per_turn[1],total_scores[1])
	if alive_bubbles < max_bubbles * 0.5 and num_restocks > 0:
		mesa_manager.spawn_num_bubbles(alive_bubbles)
		max_bubbles = alive_bubbles
		num_restocks -= 1

func _on_play_timer_timeout() -> void:
	scores_per_turn[player_turn].push_back(score_this_turn)
	total_scores[player_turn] += score_this_turn
	player_turn = (player_turn + 1) % GameManager.num_players_in_game
	play_timer.stop()
	PlayerStartTurn.emit(player_turn)
	StopBall.emit()
	print("TURNO PLAYER ", player_turn + 1)
	
func reset_game():
	player_turn = 0
	scores_per_turn.clear()
