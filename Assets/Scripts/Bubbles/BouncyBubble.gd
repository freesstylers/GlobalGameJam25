class_name BouncyBubble
extends Bubble

@export var numhits : int = 1
@export var hitColors : Array[Color] = [Color.AQUA]


func _ready() -> void:
	super._ready()
	numhits = randi_range(0,2)
	

func on_hit(body):
	numhits -= 1
	set_shader_color(hitColors[numhits])
	if numhits == 0:
		GameManager.PoolManager.HitBubble.emit()
		queue_free()

func set_shader_color(color : Color):
	bubbleShader.set_shader_parameter("bubble_color", Vector4(color.r, color.g, color.b, color.a))
