class_name BouncyBubble
extends Bubble

@export var numhits : int = 1
@export var hitColors : Array[Color] = [Color.AQUA]


func _ready() -> void:
	super._ready()
	numhits = randi_range(1,2)
	set_shader_color(hitColors[numhits - 1])
	

func on_hit(body):
	numhits -= 1
	if numhits <= 0:
		GameManager.PoolManager.HitBubble.emit()
		on_death()
		queue_free()
	else:
		$Hit.play()
		set_shader_color(hitColors[numhits - 1])

func set_shader_color(color : Color):
	bubbleShader.set_shader_parameter("bubble_color", Vector4(color.r, color.g, color.b, color.a))
	
