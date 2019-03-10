extends KinematicBody2D

var wall = 0
var velocity = Vector2()
var ACCEL = 50
var MAX_SPEED = 200
var HEIGHT = -500 #jump height
var GRAV = 20
const UP = Vector2(0, -1)
var jumps #how many jumps the player has remaining

func _ready():
	#move to the worlds start location node
	jumps = 1
	pass

func _physics_process(delta):
	if(wall > 0):
		velocity.y = min(velocity.y + GRAV*0.2, 400)
	else:
		velocity.y = min(velocity.y + GRAV, 400)
	#left and right motion
	if(Input.is_action_pressed("ui_right")):
		velocity.x = min(velocity.x + ACCEL, MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Walk")
	elif(Input.is_action_pressed("ui_left")):
		velocity.x = max(velocity.x - ACCEL, -MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Walk")
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
	#jump
	if(is_on_floor()):
		if(velocity.x == 0):
			$Sprite.play("Idle")
		if(Input.is_action_just_pressed("ui_up")):
			velocity.y = HEIGHT
	else:
		$Sprite.play("Jump")
	if(is_on_wall()):
		$Sprite.play("Wall")
		if(velocity.y < 0):
			velocity.y = lerp(velocity.y, 0, 0.05)
		if(Input.is_action_just_pressed("ui_up")):
			velocity.y = HEIGHT
			#push off from the wall
			if(velocity.x > 0):
				velocity.x = -400
			else:
				velocity.x = 400
		wall = 1
	else:
		wall = 0

	velocity = move_and_slide(velocity, UP)