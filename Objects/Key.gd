extends Area2D

func get_key():
	global.player_key += 1
	$Sprite.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$GrabPart.set_emitting(true)
	$GrabPart.set_one_shot(true)
	yield($PartTimer, "timeout")
	queue_free()