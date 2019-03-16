extends KinematicBody2D

export (int) var speed = 100
export (int) var direction = 1 #should only ever be 1 or -1
#export (int) var max_distance = 192
const UP = Vector2(0, -1)
#var GRAV = 20
var dir_change = false
var velocity = Vector2()
#var traveled = 0
var cur_speed
#var give_speed

func _ready():
	add_to_group("Platforms")
	cur_speed = speed

func _physics_process(delta):
	velocity.x = cur_speed*direction
	velocity.y = 0
	if(is_on_wall()):
		if(not dir_change):
			direction *= -1
			dir_change = true
			$Dir_Timer.start()
	
	move_and_slide(velocity, UP)

func _on_DirTimer_timeout():
	dir_change = false

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		cur_speed = 0

func _on_Area2D_body_exited(body):
	if(body.get_name() == "Player"):
		cur_speed = speed
