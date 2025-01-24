extends ProgressBar


var val = 0
var dir = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Accelerate"):
		val += dir
		if val >= 100:
			val = 100
			dir *= -1
			pass
		elif val <= 0:
			val = 0
			dir *= -1
			pass
		
		value = val
		pass
	pass
