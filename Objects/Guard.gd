extends KinematicBody2D

export (int) var speed = 100
export (int) var direction = 1 #should only ever be 1 or -1
var velocity = Vector2()
const UP = Vector2(0, -1)
var GRAV = 20
var dir_change = false
var stunned = false

func _ready():
	add_to_group("Enemies")
	$Sprite.play("Walk")

#warning-ignore:unused_argument
func _physics_process(delta):
	if(not is_on_floor()):
		velocity.y = min(velocity.y + GRAV, 400)
	
	if(not stunned):
		velocity.x = speed*direction
	
		if(direction == 1):
			$Sprite.flip_h = false
		elif(direction == -1):
			$Sprite.flip_h = true
		else: #falling case I guess
			$Sprite.play("Fall")
	
		if(is_on_wall()):
			if(not dir_change):
				direction *= -1
				dir_change = true
				$Dir_Timer.start()
	else:
		$Sprite.play("Stunned")
		velocity.x = 0
#warning-ignore:return_value_discarded
	move_and_slide(velocity, UP)


func _on_Dir_Timer_timeout():
	dir_change = false

func stun():
	stunned = true
	$Stun_Timer.start(0.5)

func _on_Stun_Timer_timeout():
	$Sprite.play("Walk")
	stunned = false
