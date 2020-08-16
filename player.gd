extends KinematicBody2D

# Variables
var speedX = 0
var speedY = 0
var velocity = Vector2(0 , 0)
var facingDirection = 0
var movingdirection = 0
var playersprite
var maxjumpcount = 1
var jumpcount = 0
var deltatime = 0
var landed
# Constants
const MAX_SPEED = 300
const MOVMULTI = 800
const JUMPFORCE = 350
const GRAVITY = 800

func _animePlayer():
	if(playersprite.get_frame()>=3):
		playersprite.set_frame(0)
	if(playersprite.get_frame()<3):
		playersprite.set_frame(playersprite.get_frame() + 1)
	deltatime = 0
	pass

func _ready():
	set_process(true)
	playersprite = get_node("Sprite")
	pass
	
func _process(delta):
	if(Input.is_action_pressed("move_jump") and jumpcount < maxjumpcount):
		speedY = -JUMPFORCE
		jumpcount += 1
		playersprite.set_frame(5)
		landed = false
	if(Input.is_action_pressed("move_left")):
		facingDirection = -1
		playersprite.set_flip_h(true)
		deltatime = deltatime + delta
		if(deltatime > 0.1 ):
			if(landed):
				_animePlayer()
	elif(Input.is_action_pressed("move_right")):
		facingDirection = 1
		playersprite.set_flip_h(false)
		deltatime = deltatime + delta
		if(deltatime > 0.1 ):
			if(landed):
				_animePlayer()
	else: 
		facingDirection = 0
		if(landed):
			playersprite.set_frame(4)
		
	if(velocity.x == 0 and landed):
		playersprite.set_frame(0)
	
	if(facingDirection!=0):
		speedX += MOVMULTI  * delta
		movingdirection = facingDirection
	else: speedX -= MOVMULTI * 2 * delta
	speedX = clamp( speedX, 0, MAX_SPEED)
	speedY += GRAVITY * delta 
	velocity.x = speedX * delta * facingDirection
	velocity.y = speedY * delta
	var moveReminder = move(velocity)
	if is_colliding():
		var normal = get_collision_normal()
		var finalmov = normal.slide(moveReminder)
		speedY = 0
		move(finalmov)
		if(normal == Vector2(0, -1)):
			jumpcount = 0
			if(!landed):
				playersprite.set_frame(0)
				landed=true
		
	# move function is the function reponsable for moving sprite
	
	
	pass
