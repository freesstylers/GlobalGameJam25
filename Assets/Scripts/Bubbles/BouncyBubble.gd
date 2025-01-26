class_name BouncyBubble
extends Bubble

@export var numhits : int = 1
@export var hitColors : Array[Color] = [Color.AQUA]
@export var alpha_colors : Array[float] = [-0.55]
@export_range(0.0, 1.0) var height_multiplier : float = 0.2
@export_range(0.0, 1.0) var noise_sample_size : float = 0.04
@export_range(0.0, 1.0) var animation_speed : float = 0.03


func _ready() -> void:
	super._ready()
	numhits = randi_range(1,2)
	set_shader_color(hitColors[numhits - 1], alpha_colors[numhits - 1])
	if numhits == 1:
		set_shader_shake(height_multiplier, noise_sample_size, animation_speed)
	

func on_hit(body):
	numhits -= 1
	if numhits <= 0:
		GameManager.PoolManager.HitBubble.emit()
		on_death()
	else:
		$Hit.play()
		set_shader_color(hitColors[numhits - 1], alpha_colors[numhits - 1])
		set_shader_shake(height_multiplier, noise_sample_size, animation_speed)
