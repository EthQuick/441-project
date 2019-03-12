extends KinematicBody2D

var wall = false
var wall_jump = false
var velocity = Vector2()
var ACCEL = 50
var MAX_SPEED = 200
var HEIGHT = -500 #jump height
var GRAV = 20
const UP = Vector2(0, -1)
var UI = 0

#Camera borders
export (int) var TOP_BORD = 0
export (int) var LEFT_BORD = 0
export (int) var RIGHT_BORD = 1280
export (int) var BOT_BORD = 360

#are we on a platform
var plat = false

func _ready():
	#move to the worlds start location node
	#set camera junk
	get_node("Camera2D").set_limit(MARGIN_TOP, TOP_BORD)
	get_node("Camera2D").set_limit(MARGIN_LEFT, LEFT_BORD)
	get_node("Camera2D").set_limit(MARGIN_RIGHT, RIGHT_BORD)
	get_node("Camera2D").set_limit(MARGIN_BOTTOM, BOT_BORD)
	#Get UI node
	UI = get_tree().get_nodes_in_group("UI")
	pass

func _physics_process(delta):
	#gravity
	if(wall):
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
		$Sprite.play("Idle")
	#jump
	if(is_on_floor()):
		velocity.y == 0
		if(velocity.x == 0):
			$Sprite.play("Idle")
		if(Input.is_action_just_pressed("ui_up")):
			velocity.y = HEIGHT
	else:
		$Sprite.play("Jump")
	#wall jump
	if(is_on_wall()):
		if(not is_on_floor()):
			$Sprite.play("Wall")
		if(velocity.y < 0):
			velocity.y = lerp(velocity.y, 0, 0.05)
		wall = true
		wall_jump = true
		$WallTimer.start()
	else:
		wall = false
	if(wall_jump):
		if(Input.is_action_just_pressed("ui_up")):
			velocity.y = HEIGHT
			#push off from the wall
			if(velocity.x > 0):
				velocity.x = -400
			else:
				velocity.x = 400
	
	var floor_v = get_floor_velocity()
	print(floor_v.x)
	#if(velocity.x != 0):
	velocity.x += floor_v.x
		
	velocity = move_and_slide(velocity, UP)

func _on_Area2D_body_entered(body):
	#TODO: actually go back to the title screen
	if(body.collision_mask == 3):
		UI[0].set_message("Game Over")
		get_tree().paused = true
	elif(body.collision_mask == 6):
		plat = true

func _on_Area2D_body_exited(body):
	if(body.collision_mask == 6):
		plat = false

func _on_WallTimer_timeout():
	wall_jump = false



