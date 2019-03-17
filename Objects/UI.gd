extends CanvasLayer

var world_name = 0

func _ready():
	add_to_group("UI")
	world_name = get_parent().get_name()
	init_world()
	update_collectables()
	$Button.hide()
	$Final_Coins.hide()
	$Total_Coins.hide()

func set_message(message):
	$StartTimer.stop()
	$Message.text = message
	$Message.show()

func hide_message():
	$Message.hide()

func init_world():
	set_message(world_name)
	$StartTimer.start()

func _on_StartTimer_timeout():
	hide_message()
	
func update_collectables():
	$Coins.text = "Coins: " + str(global.player_coins)
	$Keys.text = "Keys: " + str(global.player_key)
	
func game_over(message):
	set_message(message)
	$Coins.hide()
	$Keys.hide()
	$GOTimer.start()
	yield($GOTimer, "timeout")
	$Final_Coins.text = "World Coins: " + str(global.player_coins)
	$Final_Coins.show()
	yield($GOTimer, "timeout")
	global.world_end()
	$Total_Coins.text = "Total Coins: " + str(global.total_coins)
	$Total_Coins.show()
	yield($GOTimer, "timeout")
	$Button.show()

func _on_Button_pressed():
#warning-ignore:return_value_discarded
	get_tree().change_scene("Worlds/TitleScreen.tscn")
