extends Area2D

onready var animation = get_node("AnimationPlayer")
onready var audio = get_node("audio")
onready var root = get_node(".")
onready var collision = get_node("CollisionShape2D")

func _ready():
	animation.play("grow")
	


func _on_Area2D_area_entered(area):
	audio.stream = load("res://sound/pickup.wav")
	audio.play()
	root.visible = false
	collision.set_deferred("disabled", true)
	var parent = area.get_parent()
	parent.life_up()
	


func _on_AudioStreamPlayer2D_finished():
	queue_free()
	audio.stop()
