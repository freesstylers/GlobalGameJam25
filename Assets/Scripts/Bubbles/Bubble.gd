class_name Bubble
extends BaseBall

var bubbleShader : ShaderMaterial #seteamos los parametros con seet_shader_material

func _ready() -> void:
	super._ready()
	#Buscamos el shader y lo metemos en la variable
	bubbleShader = $RigidBody3D/BubbleMesh.get_active_material(0) as ShaderMaterial
	
	#Random seed del ruido para que no tengan la misma animacion todas las burbujas
	var fastNoise : FastNoiseLite = FastNoiseLite.new()
	fastNoise.seed = randi()
	bubbleShader.get_shader_parameter("noise").noise = fastNoise

func set_shader_color(color : Color):
	bubbleShader.set_shader_parameter("bubble_color", Vector4(color.r, color.g, color.b, color.a))
