extends KinematicBody2D

onready var audio = get_node("audio")

var velocity = Vector2.ZERO
var dir = 1

const angle = 15
const speed = 300

func movement():
	if is_on_floor():
		dir = -1
	elif is_on_ceiling():
		dir = +1
	velocity.y = dir*speed
	
	rotation_degrees += angle

func _physics_process(delta):
	movement()
	move_and_slide(velocity,Vector2.UP)


func _on_Area2D_area_entered(area):
	var Parent = area.get_parent()
	audio.play()
	Parent.dead()


func _on_AudioStreamPlayer2D_finished():
	audio.stop()
