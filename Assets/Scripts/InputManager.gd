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
		
	if event.is_action_pressed("jump"):
		pass
	elif event.is_action_pressed("up"):
		pass 
	elif event.is_action_pressed("down"):
		pass 
	elif event.is_action_pressed("left"):
		pass 
	elif event.is_action_pressed("right"):
		pass 
	elif event.is_action_pressed("drift"):
		pass 
	elif event.is_action_pressed("horny"):
		pass 
	#GameManager.current_player.do_something()
