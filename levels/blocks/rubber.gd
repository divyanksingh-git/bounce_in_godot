extends Area2D



func _on_rubber_area_entered(area):
	var parent = area.get_parent()
	parent.toggle_jump()


func _on_rubber_area_exited(area):
	var parent = area.get_parent()
	parent.toggle_jump()
