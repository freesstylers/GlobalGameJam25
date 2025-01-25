extends Node

@onready var TableRow = preload("res://Assets/Prefabs/UI/table_row.tscn")
@onready var TableCell = preload("res://Assets/Prefabs/UI/table_cell.tscn")

@export var testHoles : int
@export var testValues : PackedInt32Array
@export var testValuesP2 : PackedInt32Array

func _ready() -> void:
	Fill(testHoles, testValues, 87, false, testValuesP2, 76)
	pass

func FillP1(size : int, values : PackedInt32Array, total : int):
	Fill(size, values, total, false, [], 0)

func Fill(size : int, values : PackedInt32Array, total : int, hasP2 : bool, valuesP2 : PackedInt32Array, totalP2 : int):
	
	
	var rowNums = TableRow.instantiate()
	$TableRowContainer.add_child(rowNums)
	var rowScores = TableRow.instantiate()
	$TableRowContainer.add_child(rowScores)
	var rowScoresP2
	
	if hasP2:
		rowScoresP2 = TableRow.instantiate()
		$TableRowContainer.add_child(rowScoresP2)
		pass
	
	AddCell(rowNums, "Level")
	AddCell(rowScores, "Player 1" if hasP2 else "Score")
	
	if hasP2:
		AddCell(rowScoresP2, "Player 2")
		pass
	
	var valuesSize = values.size()
	var valuesSizeP2 = valuesP2.size()
	
	for r in range(size):
		AddCell(rowNums, r + 1)
		AddCell(rowScores, values[r] if r < valuesSize else "-")
	
		if hasP2:
			AddCell(rowScoresP2, valuesP2[r] if r < valuesSizeP2 else "-")
			pass
		pass
	
	AddCell(rowNums, "Total")
	AddCell(rowScores, total)
	
	if hasP2:
		AddCell(rowScoresP2, totalP2)
		pass
	pass

func AddCell(row, val):
	var cell = TableCell.instantiate()
	cell.text = str(val)
	
	row.add_child(cell)
	pass
