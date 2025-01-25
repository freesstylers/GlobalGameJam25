class_name BouncyBubble
extends BaseBall

@export var numhits : int = 1
@export var hitColors : Array[Color] = [Color.AQUA]

var bubbleShader : ShaderMaterial #seteamos los parametros con seet_shader_material

func _ready() -> void:
	#Buscamos el shader y lo metemos en la variable
	var count = $RigidBody3D/BubbleMesh.get_surface_override_material_count()
	bubbleShader = $RigidBody3D/BubbleMesh.get_active_material(0) as ShaderMaterial
	
	
	pass

func _ready() -> void:
	numhits = randi_range(0,2)

func on_hit(body):
	numhits -= 1
	set_shader_color(hitColors[numhits])
	if numhits == 0:
		queue_free()

func set_shader_color(color : Color):
	bubbleShader.set_shader_parameter("bubble_color", Vector4(color.r, color.g, color.b, color.a))
