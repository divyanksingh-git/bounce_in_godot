extends Node2D


onready var root = get_node(".")
var ring_count
func _ready():
	var ring = get_node("ring")
	var player = get_node("player")
	var portal = get_node("portal/portal")
	if ring:
		ring_count = ring.get_child_count()
	player.update_total_ring(ring_count,portal)
	if portal:
		portal.total_ring(ring_count)

