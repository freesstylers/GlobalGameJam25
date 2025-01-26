class_name LoadingScreen extends Control

signal loading_screen_faded_in()
signal loading_screen_faded_out()

@onready var minLoadingTimeTimer : Timer = $MinLoadingTime

func _ready():
	modulate.a = 0
	
func StartLoadingScreen():
	modulate.a = 0
	var localTween  = create_tween()
	localTween.tween_property(self, "modulate:a", 1, 0.5)
	localTween.tween_callback(func():
		minLoadingTimeTimer.start()
		loading_screen_faded_in.emit()
		)
		
func EndLoadingScreen():
	var localTween  = create_tween()
	localTween.tween_property(self, "modulate:a", 0, 0.5)
	localTween.tween_callback(func():
		loading_screen_faded_out.emit()
		)
