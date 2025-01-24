class_name SceneManagement extends Node

enum GAME_SCENE {MAIN_MENU, PLAY_SCENE, NULL}
@export var Scenes : Array[SceneResource] = []
@onready var loadingScreen : LoadingScreen = $LoadingScreen

var isLoadingScene : bool = false
var currentSceneEnum : GAME_SCENE = GAME_SCENE.NULL
var currentScene : Node = null

func _ready() -> void:
	change_to_scene(GAME_SCENE.MAIN_MENU)
	
func change_to_scene(nextScene):
	if isLoadingScene or currentSceneEnum == nextScene:
		return
		
	isLoadingScene = true
	currentSceneEnum = nextScene
	loadingScreen.StartLoadingScreen()

func load_scene(): #FORCE
	pass
################################################################
#####################FADE IN / FADE OUT#########################
################################################################

func on_loading_screen_faded_in():
	#Swap the current scene to the one requested
	if currentScene != null:
		currentScene.queue_free()
	currentScene = get_packed_scene(currentSceneEnum).instantiate()
	add_child(currentScene)

func on_loading_screen_faded_out():
	isLoadingScene = false


func get_packed_scene(scn_enum : GAME_SCENE):
	for currentScenePair in Scenes:
		if currentScenePair.scene_enum == scn_enum:
			return currentScenePair.scene_packed_scene
	return null
