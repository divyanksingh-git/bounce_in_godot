extends Area2D

onready var audio = get_node("audio")

func _on_Area2D_area_entered(area):
	var Parent = area.get_parent()
	audio.play()
	Parent.dead()
	


func _on_audio_finished():
	audio.stop()
