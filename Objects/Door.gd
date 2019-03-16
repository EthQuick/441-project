extends StaticBody2D

var open = false

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player" and global.player_key > 0):
		print("opening")
		open = true
		$Sprite.hide()
		$Sprite2.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
