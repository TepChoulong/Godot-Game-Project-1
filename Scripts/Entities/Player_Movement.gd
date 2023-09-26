extends CharacterBody2D

@onready var Animator = get_node("AnimationPlayer")


@export var SPEED : float = 250.0
@export var JUMP_VELOCITY = 400.0
@export var FALLMUTIPLIER : float = -2.5
@export var LOWJUMPMUTIPLIER : float = -2.0

@export var cayote_time : int = 15
var cayote_counter : int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	if is_on_floor():
		cayote_counter = cayote_time # Set the cayate_counter is equal to cayote_time
	
	if not is_on_floor():
		velocity.y += gravity * delta  # Add the gravity.
		
		# check the cayote counter
		if cayote_counter > 0:
			cayote_counter -= 1
		
	# Handle Jump.
	Jump(delta)
	
	# Handle Better Jump
	if velocity.y < 0:
		velocity += Vector2.UP * gravity * (FALLMUTIPLIER + 1) * delta
	elif velocity.y > 0 and not Input.is_action_pressed("Jump"):
		velocity += Vector2.UP * gravity * (LOWJUMPMUTIPLIER + 1) * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	
	#Facing
	if direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	elif direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	
	# Handle the animations and movement
	if direction:
		velocity.x = direction * SPEED
		
		if velocity.y == 0:
			Animator.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if velocity.y == 0:
			Animator.play("Idle")
			
	if velocity.y > 0:
		Animator.play("Fall")
	
	move_and_slide()

func Jump(delta : float) -> void:
	if Input.is_action_just_pressed("Jump") and cayote_counter > 0:
		velocity.y = -JUMP_VELOCITY
		Animator.play("Jump")
		cayote_counter = 0
		
	if Input.is_action_just_released("Jump"):
		if velocity.y < 0:
			velocity = Vector2.DOWN * gravity * (FALLMUTIPLIER + 1) * delta
