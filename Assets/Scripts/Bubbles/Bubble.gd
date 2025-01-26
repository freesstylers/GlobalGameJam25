class_name Bubble
extends BaseBall

var bubbleShader : ShaderMaterial #seteamos los parametros con seet_shader_material
var particle_system : GPUParticles3D

func _ready() -> void:
	super._ready()
	#Buscamos el shader y lo metemos en la variable
	bubbleShader = $RigidBody3D/BubbleMesh.get_active_material(0) as ShaderMaterial
	
	#Random seed del ruido para que no tengan la misma animacion todas las burbujas
	var fastNoise : FastNoiseLite = FastNoiseLite.new()
	fastNoise.seed = randi()
	bubbleShader.get_shader_parameter("noise").noise = fastNoise
	
	#sistema de particulas para la explosion de la burbuja
	particle_system = $DeathParticles as GPUParticles3D
	particle_system.finished.connect(on_finish_particles)

func set_shader_color(color : Color, alpha : float):
	bubbleShader.set_shader_parameter("bubble_color", Vector4(color.r, color.g, color.b, color.a))
	bubbleShader.set_shader_parameter("alpha_bubble", alpha)
	
func set_shader_shake(height_multiplier : float, noise_sample_size : float, animation_speed : float):
	bubbleShader.set_shader_parameter("height_multiplier", height_multiplier)
	bubbleShader.set_shader_parameter("noise_sample_size", noise_sample_size)
	bubbleShader.set_shader_parameter("animation_speed", animation_speed)
	
func on_death() -> void:
	$RigidBody3D.queue_free()
	particle_system.position = $RigidBody3D.position
	particle_system.emitting = true

func on_finish_particles():
	super.on_death()
