extends CharacterBody2D

@onready var Animator = get_node("AnimationPlayer")

@export var SPEED : float = 250.0
@export var JUMP_VELOCITY : float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		Animator.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	
	#Facing
	if direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	elif direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	
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

