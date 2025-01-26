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
@export var player2_prefab : PackedScene
@onready var play_timer : Timer = $PlayTimer
@onready var scoreBoard : ScoreBoardManager = $GameUI/ParTable
@onready var SkillIssue = $GameUI/SkillIssue
@onready var NiceShot = $GameUI/NiceShot
@onready var LetsGoooo = $GameUI/LetsGo
@onready var skyboxObj : WorldEnvironment = $WorldEnvironment
@export var caster_audios : Array[AudioStreamPlayer] = []
@export var skyboxes : Array

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
	var i = randi() % skyboxes.size()
	skyboxObj.environment.sky.sky_material.panorama = skyboxes[i]
	on_start_game()

func on_start_game():
	scoreBoard.Fade(0,0) #Hide the scoreboard
	if mesa_manager:
		mesa_manager.queue_free()
	mesa_manager = table_prefabs[randi()%table_prefabs.size()].instantiate()
	add_child(mesa_manager)
	mesa_manager.scale = Vector3.ZERO
	var tween = create_tween()
	tween.tween_property(mesa_manager,"scale", Vector3(1.5,1.5,1.5), 1)
	mesa_manager.scale = Vector3(1.5,1.5,1.5)
	mesa_manager.spawn_bubbles()
	mesa_manager.spawn_players()
	PlayerStartTurn.emit(player_turn)
	max_bubbles = alive_bubbles
	for j in GameManager.num_players_in_game:
		var control = $GameUI/Control
		control.activateUI_Player(j)
	reset_game()
		
func start_play(charge):
	play_timer.start()
	score_this_turn = 0
	if GameManager.num_players_in_game == 1:
		num_turns += 1
	
func new_bubble():
	alive_bubbles += 1
	
func hit_bubble():
	score_this_turn += 1
	total_scores[player_turn] += 1
	alive_bubbles -= 1
	#if GameManager.num_players_in_game == 1:
		#hit_bubble_1player()
	#else:
		#hit_bubble_multiplayer()
		
	
		
	$AudioStreamPlayer.play()
	
	if alive_bubbles == 0:
		play_timer.stop()
		scores_per_turn[player_turn].push_back(score_this_turn)
		StopBall.emit()

		GameEnded.emit()
		scoreBoard.Fill(num_turns, scores_per_turn[0],total_scores[0], GameManager.num_players_in_game > 1, scores_per_turn[1],total_scores[1])
		return
	
#func hit_bubble_1player():
	#if alive_bubbles <= 0:
		#scoreBoard.Fill(num_turns, scores_per_turn[0],total_scores[0], GameManager.num_players_in_game > 1, scores_per_turn[1],total_scores[1])
	#else:
		#pass
	#
#func hit_bubble_multiplayer():
	#if alive_bubbles <= 0:
		#GameEnded.emit()
		#scoreBoard.Fill(num_turns, scores_per_turn[0],total_scores[0], GameManager.num_players_in_game > 1, scores_per_turn[1],total_scores[1])
	#if alive_bubbles < max_bubbles * 0.5 and num_restocks > 0:
		#mesa_manager.spawn_num_bubbles(alive_bubbles)
		#max_bubbles = alive_bubbles
		#num_restocks -= 1

func _on_play_timer_timeout() -> void:
	#REACTIONS	
	caster_audios[clampi(score_this_turn,0,caster_audios.size()-1)].play()
	StopBall.emit()
	
	if score_this_turn == 0:
		SkillIssue.visible = true;
		
		var tween = create_tween()
		tween.tween_property(SkillIssue, "position:y", 272, 0.2)
		pass
	elif score_this_turn == 2:
		NiceShot.visible = true;
		var tween = create_tween()
		tween.tween_property(NiceShot, "position:y", 272, 0.2)
		pass
	elif score_this_turn > 2:
		LetsGoooo.visible = true;
		var tween = create_tween()
		tween.tween_property(LetsGoooo, "position:y", 272, 0.2)
		pass
	
func on_caster_said():
	scores_per_turn[player_turn].push_back(score_this_turn)
	
	if score_this_turn == 0:
		var tween = create_tween()
		tween.tween_property(SkillIssue, "position:y", 670, 0.2)
		pass
	elif score_this_turn == 2:
		var tween = create_tween()
		tween.tween_property(NiceShot, "position:y", 670, 0.2)
		pass
	elif score_this_turn > 2:
		var tween = create_tween()
		tween.tween_property(LetsGoooo, "position:y", 670, 0.2)
		pass
	
	if alive_bubbles <= 0:
		GameEnded.emit()
		scoreBoard.Fill(num_turns, scores_per_turn[0],total_scores[0], GameManager.num_players_in_game > 1, scores_per_turn[1],total_scores[1])
		return
	if GameManager.num_players_in_game > 1 and alive_bubbles < max_bubbles * 0.5 and num_restocks > 0:
		mesa_manager.spawn_num_bubbles(alive_bubbles)
		max_bubbles = alive_bubbles
		num_restocks -= 1
	
	player_turn = (player_turn + 1) % GameManager.num_players_in_game
	PlayerStartTurn.emit(player_turn)
	
func reset_game():
	player_turn = 0
	score_this_turn = 0
	scores_per_turn.clear()
	scores_per_turn.push_back([])
	scores_per_turn.push_back([])
	total_scores.clear()
	total_scores.push_back(0)
	total_scores.push_back(0)
