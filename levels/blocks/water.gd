extends Area2D




func _on_water_area_entered(area):
	var parent = area.get_parent()
	parent.toggle_boyancy()
	


func _on_water_area_exited(area):
	var parent = area.get_parent()
	parent.toggle_boyancy()
