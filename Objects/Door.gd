extends StaticBody2D

var open = false
var UI = null

func _ready():
	UI = get_tree().get_nodes_in_group("UI")

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player" and global.player_key > 0):
		global.player_key -= 1
		UI[0].update_collectables()
		open = true
		$Particles2D.set_emitting(true)
		$Particles2D.set_one_shot(true)
		$Sprite.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
