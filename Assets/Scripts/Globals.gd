extends Node

############SIGNALS
enum INPUT_TYPE { KEYBOARD, CONTROLLER}
var last_input_used : INPUT_TYPE = INPUT_TYPE.KEYBOARD

###########END_SIGNALS

###########VARIABLES
var players : Array[Player] = []
var current_player = null
var SceneManager : SceneManagement = null
var PoolManager : PoolManagement = null
var ButtonSFX : AudioStreamPlayer2D = null
###########END_VARIABLES

func playButtonSFX():
	ButtonSFX.play()
