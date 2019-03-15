extends Area2D

var speed = 200
export (int) var dir = 0
var velocity = Vector2()

func _physics_process(delta):
	velocity.x = speed*delta*dir
	set_position(position + velocity)\

func _on_Bullet_body_entered(body):
	if(body.get_name() == "TileMap"):
		#also throw out some particles
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
