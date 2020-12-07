extends Area2D
 
onready var node = get_node(".")
onready var sprite = get_node("Sprite")
onready var collision = get_node("CollisionShape2D")
onready var timer = get_node("Timer")
onready var audio = get_node("audio")

var parent 

func _on_wing_area_entered(area):
	audio.stream = load("res://sound/pickup.wav")
	audio.play()
	parent = area.get_parent()
	parent.toggle_fly()
	sprite.visible = false
	collision.set_deferred("disabled", true)
	timer.set_wait_time(3)
	timer.start()
	
	

func _on_Timer_timeout():
	parent.toggle_fly() 
	sprite.visible = true
	collision.set_deferred("disabled", false)
	timer.stop()


func _on_AudioStreamPlayer2D_finished():
	audio.stop()
