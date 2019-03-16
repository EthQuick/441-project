#Logic for creating the bullet from here: https://www.youtube.com/watch?v=rY7wzK59-Jw
extends StaticBody2D

export (int) var direction = 1
export (int) var aimx
export (int) var aimy

var target = null
var aim = Vector2()
var aiming = false
var firing = false

const BULLET = preload("Bullet.tscn")

func _ready():
	if(direction == -1):
		$Sprite.flip_h = true
	aim.x = aimx
	aim.y = aimy
	$LoS.cast_to = aim
	$LoS.add_exception(get_node("../TileMap"))
	$Position2D.position.x = 16*direction

#warning-ignore:unused_argument
func _physics_process(delta):
	if($LoS.is_colliding()):
		target = $LoS.get_collider()
		if(target and not aiming and target.get_name() == "PlayerBod"):
			$AimTimer.start()
			aiming = true
	if(firing):
		var bullet = BULLET.instance()
		get_parent().add_child(bullet)
		bullet.set_position($Position2D.global_position)
		bullet.dir = direction
		firing = false

func _on_AimTimer_timeout():
	firing = true
	aiming = false
