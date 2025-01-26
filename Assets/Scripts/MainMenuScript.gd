class_name MainMenuManager extends Control

@onready var credits : Control = $credits
@onready var tutorial : Control = $tutorial
@onready var MainButtonContainer : Control = $MainButtonContainer

func TogglePlayMenu(state: bool):
	GameManager.playButtonSFX()
	GameManager.SceneManager.change_to_scene(SceneManagement.GAME_SCENE.PLAY_SCENE)

func _on_level_button_down(level: int):
	GameManager.playButtonSFX()
	#get_tree().root.get_node("SceneManager").startGame(level)

func _on_credits_button_down():
	GameManager.playButtonSFX()
	credits.visible = true	
	MainButtonContainer.visible = false;

func _on_credits_back_button_down():
	GameManager.playButtonSFX()
	credits.visible = false
	MainButtonContainer.visible = true;

func _on_tutorial_button_down():
	GameManager.playButtonSFX()
	tutorial.visible = true
	MainButtonContainer.visible = false;

func _on_tutorial_back_button_down():
	GameManager.playButtonSFX()
	tutorial.visible = false
	MainButtonContainer.visible = true;

#########################################################
################### EXTERNAL LINKS ######################
#########################################################

func FreeStylers():
	get_tree().root.get_node("SceneManager/ButtonSFX").play()
	OS.shell_open("https://freestylers-studio.itch.io/")

func Jam():
	get_tree().root.get_node("SceneManager/ButtonSFX").play()
	OS.shell_open("https://globalgamejam.org/")
	
func Twitter():
	get_tree().root.get_node("SceneManager/ButtonSFX").play()
	OS.shell_open("https://twitter.com/FreeStylers_Dev")
