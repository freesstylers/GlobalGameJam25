extends AweSplashScreenViewport

@onready var logo_container := $ViewportContainer/Viewport/AspectNode/LogoContainer
@onready var logo := $ViewportContainer/Viewport/AspectNode/LogoContainer/Logo

@onready var info_node := $ViewportContainer/Viewport/AspectNode/InfoNode
@onready var title_node := $ViewportContainer/Viewport/AspectNode/TitleNode
@onready var bg_color := $CanvasLayer/ColorRect

@export_file("*png") var logo_path = "res://src/demo_collection/dark/src/logo.png"
@export var title := "GODOT"
var description := "TRIGGER WARNINGS: ALCHOHOL + CACAHUETES\n\nTodos los valores y actitudes presentes en este juego\n son una performance y carecen de todo tipo de apoyo.\n\n\nSolo nos vanagloriamos de nuestra propia estupidez.\n\n\nAtentamente, FreeStylers Studio "

@export var duration := 4.0
@export var background_color: Color = Color8(0, 0, 0, 255)
@export var vfx_color: Color = Color8(59, 235, 38, 255)

@export var title_font_size := 230.0
@export var description_font_size := 120.0

var logo_color =  Color8(255, 255, 255, 255)
var font_color := Color.WHITE


# config shader hologram
const HOLOGRAM_VALUE = 0.75
const HOLOGRAM_NOISE = 10.0
const HOLOGRAM_SPEED = 1.0


func get_splash_screen_name() -> String:
	return "Dark"


func _ready():
	super._ready()
	config()


func config():
	bg_color.color = background_color
	if logo_path != "":
		logo.texture = load_texture(logo_path)
	else:
		logo.visible = false
	#logo.modulate = logo_color
	
	var center_point = self.origin_size / 2.0
	#logo_container.modulate = logo_color
	#logo_container.position = center_point + Vector2(0, -100)
	#logo_container.scale = Vector2(0.8, 0.8)
	
	# Config TitleNode
	title_node.font.fixed_size = title_font_size
	title_node.modulate = font_color
	title_node.text = title
	title_node.position = center_point + Vector2(0, 50)
	
	# Config InfoNode
	info_node.font.fixed_size = description_font_size
	info_node.modulate = font_color
	info_node.text = description
	info_node.position = center_point + Vector2(0, 225)
	
	config_shader()
	
	logo_container.modulate.a = 0
	title_node.modulate.a = 0
	info_node.modulate.a = 0


func config_shader():
	_set_shader_f_value("hologram_value", HOLOGRAM_VALUE)
	_set_shader_f_value("hologram_noise_x", HOLOGRAM_NOISE)
	_set_shader_f_value("hologram_speed", HOLOGRAM_SPEED)
	_set_shader_color_value("tint_color", vfx_color)
	

func play():
	main_animation()

func main_animation():
	if logo.visible:
		gd.fade_alpha_to(1, 1).with_delay(0.1).start(logo_container)
	#gd.fade_alpha_to(1, 1).with_delay(duration * 0.25).start(title_node)
	gd.fade_alpha_to(1, 1).with_delay(0.5).start(info_node)
	
	gd.sequence([
		gd.wait(duration),
		gd.fade_alpha_to(0.0, duration * 0.2),
		gd.perform("finished_animation", self) # finished and move other screen
	])\
	.start(self.aspect_node)
