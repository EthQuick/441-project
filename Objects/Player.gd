extends KinematicBody2D

var wall = false
var wall_jump = false
var velocity = Vector2()
var ACCEL = 50
var MAX_SPEED = 200
var MIN_SPEED = 0
var HEIGHT = -500 #jump height
var GRAV = 20
const UP = Vector2(0, -1)
var UI = 0
var moving = false
#platform junk
var plat = false #for tracking if we are on a platform
var plat_obj = null #The platform that we are on

#Camera borders
export (int) var TOP_BORD = 0
export (int) var LEFT_BORD = 0
export (int) var RIGHT_BORD = 1280
export (int) var BOT_BORD = 360

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
	elif(plat):
		velocity.y = min(velocity.y, 0)
	else:
		velocity.y = min(velocity.y + GRAV, 400)
	#left and right motion
	if(Input.is_action_pressed("ui_right")):
		velocity.x = min(velocity.x + ACCEL, MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Walk")
		moving = true
	elif(Input.is_action_pressed("ui_left")):
		velocity.x = max(velocity.x - ACCEL, -MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Walk")
		moving = true
	else:
		velocity.x = lerp(velocity.x, MIN_SPEED, 0.2)
		$Sprite.play("Idle")
		moving = false
	#jump
	if(is_on_floor() or plat):
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
		#print(velocity.x)
	if(plat):
		MIN_SPEED = plat_obj.speed * plat_obj.direction
	velocity = move_and_slide(velocity, UP) #when colliding with the floor x is set to 0 it seems
func _on_Area2D_body_entered(body):
	#TODO: actually go back to the title screen
	if("Guard" in body.get_name()):
		UI[0].set_message("Game Over")
		get_tree().paused = true

func _on_WallTimer_timeout():
	wall_jump = false

func _on_Area2D_area_entered(area):
	if("Bullet" in area.get_name() or area.get_name() == "KillBox"):
		UI[0].set_message("Game Over")
		get_tree().paused = true
	elif("Key" in area.get_name()):
		global.player_key += 1
		area.free()

func _on_Plat_Det_body_entered(body):
	if("Platform" in body.get_name()):
		plat = true
		plat_obj = get_node("../" + body.get_name())
		MIN_SPEED = body.speed * body.direction

func _on_Plat_Det_body_exited(body):
	if("Platform" in body.get_name()):
		plat = false
		plat_obj = null
		MIN_SPEED = 0
