extends CanvasLayer


func update_gui(health_count,ring_count):
	var ring = get_node("ring/rings")
	var health = get_node("health/health")
	ring.text = ring_count
	health.text = health_count
