extends KinematicBody2D

var velocity = Vector2.ZERO
var input_dir
var jumping = false
var dead = false
var life = 3
var checkpoint_pos =[170,110]
var ring_after = [] 
var flying = false
var ring_before = []
var curren_size = 0.5
var boyancy = 0
var gravity = 50
var jumpSpeed = 1200
var total_ring = 0
var boyance_enabled = false
var portal
var in_portal = false

const rubberJump = 2200
const maxSpeed = 300
const acceleration = 0.1
const angle = 6
const Max_jumpSpeed = 1200
const maxgravity = 50

onready var sprite = get_node("AnimatedSprite")
onready var leftRay = get_node("left")
onready var rightRay = get_node("right")
onready var middleRay = get_node("middle")
onready var audio = get_node("audio")

func _ready():
	sprite.frame = 0
	start(checkpoint_pos)
func movement():
	#movement
	input_dir = int(Input.get_action_strength("right")) - int(Input.get_action_strength("left"))
	velocity.x = lerp(velocity.x,maxSpeed*input_dir,acceleration)
	# gravity and ceiling logic
	gravity()
	#jump
	if Input.is_action_pressed("jump") and jumping == false:
		jump()
	if flying == true:
		jumping = false
	elif (jumping==true and is_on_floor()):
		jumping = false
	#rotate
	rotation()
	
func gravity():
	if is_on_floor():
		if input_dir == 0:
			if leftRay.is_colliding() and middleRay.is_colliding():
				velocity.x = 250
				velocity.y = 250
			if rightRay.is_colliding() and middleRay.is_colliding():
				velocity.x = -250
				velocity.y = 250
		else:
			if leftRay.is_colliding() and middleRay.is_colliding() and Input.is_action_pressed("right"):
				velocity.y = maxSpeed
			elif rightRay.is_colliding() and middleRay.is_colliding() and Input.is_action_pressed("left"):
				velocity.y = maxSpeed
			else:
				velocity.y = 0
		if boyance_enabled == true:
			if is_on_floor():
				velocity.y = -10
	elif is_on_ceiling():
		velocity.y = 1
	if not is_on_floor():
		velocity.y += gravity

func rotation():
	if not is_on_wall():
		sprite.rotation_degrees += (velocity.x/100)*2
		if leftRay.is_colliding() and middleRay.is_colliding() and input_dir == 0:
			sprite.rotation_degrees += angle
		elif rightRay.is_colliding() and middleRay.is_colliding() and input_dir == 0:
			sprite.rotation_degrees -= angle

func jump():
	if flying == false:
		audio.stream = load("res://sound/jump.wav")
		audio.play()
	jumping = true
	velocity.y = 0
	velocity.y -= jumpSpeed

func dead():
	var parent = sprite.get_parent()
	var collision = parent.get_node("CollisionShape2D")
	collision.set_deferred("disabled", true)
	sprite.rotation_degrees = 0
	sprite.frame = 1
	velocity.x = 0
	velocity.y = 0
	dead = true
	life = life - 1
	update_ring_coin()

func start(checkpoint):
	if life == 0:
		get_tree().reload_current_scene()
	else:
		for i in ring_after:
			i.ring_taken = false
			
		var player = sprite.get_parent()
		var collision = player.get_node("CollisionShape2D")
		var x = checkpoint[0]
		var y = checkpoint[1]
		in_portal = false
		jumpSpeed = Max_jumpSpeed
		collision.set_deferred("disabled", false)
		dead = false
		flying = false
		velocity.x = 0
		velocity.y = 0 
		sprite.rotation_degrees = 0
		sprite.frame = 0
		player.position.x = x
		player.position.y = y
		player.scale.x = curren_size
		player.scale.y = curren_size
		boyancy = 0
		gravity = maxgravity - boyancy
		ring_after.clear()
		

func update_checkpoint():
	var player = sprite.get_parent()
	checkpoint_pos[0]= player.position.x
	checkpoint_pos[1] = player.position.y
	for i in ring_after:
		ring_before.append(i)
	ring_after = []
	curren_size = player.scale.x

func ring_count(i):
	ring_after.append(i)
	update_ring_coin()

func toggle_fly():
	if flying == true:
		flying = false
		sprite.frame = 0
	else:
		flying = true
		sprite.frame = 2

func size_up():
	var parent = sprite.get_parent()
	parent.scale.x = 0.7
	parent.scale.y = 0.7

func size_down():
	var parent = sprite.get_parent()
	parent.scale.x = 0.5
	parent.scale.y = 0.5

func toggle_boyancy():
	var parent = sprite.get_parent()
	var scale = str(parent.scale.x)
	if boyancy == 0:
		if scale == "0.7":
			boyancy = 65
			boyance_enabled = true
		if scale == "0.5":
			boyancy = -15
	else:
		boyancy = 0
		boyance_enabled = false
	gravity = maxgravity - boyancy

func toggle_jump():
	if jumpSpeed == Max_jumpSpeed:
		jumpSpeed = rubberJump
	else:
		jumpSpeed = Max_jumpSpeed

func life_up():
	if life > 0:
		life = life +1
		var root = get_node("")
		update_ring_coin()

func update_ring_coin():
	var gui = get_node("GUI")
	var root = get_node(".")
	var health = str(life)
	var ring = str(len(ring_after)+len(ring_before))+"/"+str(total_ring)
	gui.update_gui(health,ring)
	if portal:
		portal.ring_taken(len(ring_after)+len(ring_before))
	
func update_total_ring(ring,portal_node):
	total_ring = ring
	portal = portal_node

func portal():
	in_portal = true
	velocity.x = 0
	velocity.y = 0
	
		
	

func _physics_process(delta):
	if not dead and not in_portal:
		movement()
		update_ring_coin()
	if dead and Input.is_action_pressed("jump"):
		start(checkpoint_pos)
	move_and_slide(velocity,Vector2.UP)


func _on_AudioStreamPlayer2D_finished():
	audio.stop()
