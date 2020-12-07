extends Area2D

onready var collision = get_node("CollisionShape2D")
onready var animated_sprite = get_node("AnimatedSprite")
onready var audio = get_node("audio")

var parent
var total_ring 
var portal 
var playing = false

func _ready():
	portal = false
	animated_sprite.animation = "portal"
	animated_sprite.play()
	animated_sprite.visible = false
	collision.set_deferred("disabled", true)
	print("ready")

func total_ring(ring):
	total_ring = str(ring)

func ring_taken(ring):
	var ring_taken = str(ring)
	if ring_taken == total_ring and portal == false:
		print("true")
		enable_portal()
	
func enable_portal():
	portal = true
	animated_sprite.visible = true
	collision.set_deferred("disabled", false)



func _on_portal_area_entered(area):
	parent = area.get_parent()
	audio.play()
	playing = true
	parent.portal()


func _on_audio_finished():
	audio.stop()
	playing = false
	get_tree().reload_current_scene()

func _process(delta):
	if playing == true:
		if str(parent.scale.x) == str(0.5):
			parent.scale.x -= 0.0015
			parent.scale.y -= 0.0015
		else:
			parent.scale.x -= 0.00215
			parent.scale.y -= 0.00215
