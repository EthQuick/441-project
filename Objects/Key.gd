extends Area2D

export (String) var type
var UI = null

func _ready():
	#check the type and set up accordingly
	if(type == "Key"):
		$Key_Sprite.show()
		$Coin_Sprite.hide()
	elif(type == "Coin"):
		$Coin_Sprite.show()
		$Key_Sprite.hide()
	UI = get_tree().get_nodes_in_group("UI")

func get_key():
	if(type == "Key"):
		global.player_key += 1
		$Key_Sprite.hide()
	elif(type == "Coin"):
		global.player_coins += 1
		$Coin_Sprite.hide()
	UI[0].update_collectables()
	$CollisionShape2D.set_deferred("disabled", true)
	$GrabPart.set_emitting(true)
	$GrabPart.set_one_shot(true)
	yield($PartTimer, "timeout")
	queue_free()