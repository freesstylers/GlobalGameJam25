class_name ScoreBoardManager extends Control

@onready var TableRow = preload("res://Assets/Prefabs/UI/table_row.tscn")
@onready var TableCell = preload("res://Assets/Prefabs/UI/table_cell.tscn")

#@export var testHoles : int
#@export var testValues : PackedInt32Array
#@export var testValuesP2 : PackedInt32Array

#func _ready() -> void:
	#GameManager.ScoreBoard = self
	#modulate.a = 0
	#Fill(testHoles, testValues, 87, true, testValuesP2, 76)

func Fade(target_alpha : float , fade_length : float):
	var local_tween = create_tween()
	local_tween.tween_property(self, "modulate:a", target_alpha, fade_length)

func FillP1(size : int, values : PackedInt32Array, total : int):
	Fill(size, values, total, false, [], 0)

func Fill(size : int, values : PackedInt32Array, total : int, hasP2 : bool, valuesP2 : PackedInt32Array, totalP2 : int):
	Fade(1, 1)
	var rowNums = TableRow.instantiate()
	$TableRowContainer.add_child(rowNums)
	var rowScores = TableRow.instantiate()
	$TableRowContainer.add_child(rowScores)
	var rowScoresP2
	
	if hasP2:
		rowScoresP2 = TableRow.instantiate()
		$TableRowContainer.add_child(rowScoresP2)
	
	AddCell(rowNums, "Turn")
	AddCell(rowScores, "Player 1" if hasP2 else "Score")
	
	if hasP2:
		AddCell(rowScoresP2, "Player 2")
	
	var valuesSize = values.size()
	var valuesSizeP2 = valuesP2.size()
	
	for r in range(size):
		AddCell(rowNums, r + 1)
		AddCell(rowScores, values[r] if r < valuesSize else "-")
	
		if hasP2:
			AddCell(rowScoresP2, valuesP2[r] if r < valuesSizeP2 else "-")
	
	AddCell(rowNums, "Total")
	AddCell(rowScores, total)
	
	if hasP2:
		AddCell(rowScoresP2, totalP2)

func AddCell(row, val):
	var cell = TableCell.instantiate()
	cell.text = str(val)
	
	row.add_child(cell)


func _on_another_game_pressed() -> void:
	GameManager.playButtonSFX()
	#RELOAD LEVEL
	GameManager.SceneManager.change_to_scene(SceneManagement.GAME_SCENE.PLAY_SCENE)

func _on_main_menu_button_pressed() -> void:
	GameManager.playButtonSFX()
	GameManager.SceneManager.change_to_scene(SceneManagement.GAME_SCENE.MAIN_MENU)
