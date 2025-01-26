class_name InputManager extends Node

@export var dead_zone : float = 0.1

func _input(event):
	if event is InputEventMouse:
		return 
	
	if event is InputEventJoypadMotion:
		dead_zone = 0.1
		GameManager.last_input_used = GameManager.INPUT_TYPE.CONTROLLER
	elif event is InputEventKey:
		dead_zone = 0.0
		GameManager.last_input_used = GameManager.INPUT_TYPE.KEYBOARD
