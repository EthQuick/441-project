extends KinematicBody2D

export (int) var speed = 100
export (int) var direction = 1 #should only ever be 1 or -1
export (int) var max_distance = 192
const UP = Vector2(0, -1)
var GRAV = 20
var dir_change = false
var velocity = Vector2()
var traveled = 0


func _ready():
	add_to_group("Platforms")

func _process(delta):
	velocity.x = speed*direction*delta
	traveled += velocity.x
	if(abs(traveled) >= max_distance):
		direction *= -1
		traveled = 0
	
	set_position(position + velocity)

func _on_DirTimer_timeout():
	dir_change = false
