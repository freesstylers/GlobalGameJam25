class_name Player_UI_Controller extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.PoolManager.GameStart.connect(updateUI)
	pass
	#PoolManagement.HitBubble.connect(updateUI())

func activateUI_Player(num):
	self.get_child(num).visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func updateUI():
		var aux = get_child(GameManager.PoolManager.player_turn)
		if aux.visible == true:
			aux = aux as Player_UI
			aux.score.text = str(GameManager.PoolManager.total_scores[GameManager.PoolManager.player_turn])
