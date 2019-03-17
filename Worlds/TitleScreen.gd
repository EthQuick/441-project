extends CanvasLayer

func _ready():
	get_tree().paused = false
	global.game_start()

func _on_Button_pressed():
#warning-ignore:return_value_discarded
	get_tree().change_scene("Worlds/World-1.tscn")
