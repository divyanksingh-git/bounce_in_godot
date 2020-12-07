extends StaticBody2D

onready var audio = get_node("audio")

func _on_Area2D_area_entered(area):
	var parent = area.get_parent()
	if str(parent.scale.x) == str(0.5):
		audio.stream = load("res://sound/size.wav")
		audio.play()
	parent.size_up()


func _on_AudioStreamPlayer2D_finished():
	audio.stop()
