class_name BouncyBubble
extends BaseBall

@export var numhits : int = 1

func on_hit(body):
	numhits -= 1
	if numhits == 0:
		queue_free()
