extends Area2D

onready var audio = get_node("audio")
onready var collision = get_node("CollisionPolygon2D")
onready var root = get_node(".")

func _on_checkpoint_area_entered(area):
	audio.stream = load("res://sound/pickup.wav")
	audio.play()
	root.visible = false
	collision.set_deferred("disabled", true)
	var Parent = area.get_parent()
	Parent.update_checkpoint()

	
func _on_AudioStreamPlayer2D_finished():
	audio.stop()
	queue_free()
