extends CanvasLayer

var world_name = 0

func _ready():
	add_to_group("UI")
	world_name = get_parent().get_name()
	init_world()

func set_message(message):
	$StartTimer.stop()
	$Message.text = message
	$Message.show()

func hide_message():
	$Message.hide()

func init_world():
	set_message(world_name)
	$StartTimer.start()

func _on_StartTimer_timeout():
	hide_message()
