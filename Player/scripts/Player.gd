extends CharacterBody2D
#sprite by https://chierit.itch.io/elementals-wind-hashashin


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var coyote_jump = $coyoteJump
@export var movement_data : PlayerMovementData
var airAction = true
var canMove = true
var facingLeft = false
var newWallJump

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	var direction = Input.get_axis("left", "right")
	var was_on_floor = is_on_floor()
	
	# Add the gravity.
	apply_gravity(delta)
	
	handleJump(delta)
	handleWallJump()
	#flip()
	
	
	#handle acceleration
	movement(direction, delta)
	
	updateAnim(direction)
	applyAirResistance(direction, delta)
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	
	if just_left_ledge:
		coyote_jump.start()


func movement(direction, delta):
	#handle acceleration
	if canMove == true:
		if direction:
			velocity.x = move_toward(velocity.x, movement_data.speed*direction, movement_data.acceleration*delta)
		else:
			#handle friction
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, movement_data.friction*delta)

func handleJump(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravityScale * delta
	if Input.is_action_just_released("jump") and velocity.y < movement_data.jumpVelocity/2:
			velocity.y = movement_data.jumpVelocity/2
	if canMove:
	# Handle Jump.
		if is_on_floor() or coyote_jump.time_left > 0.00:
			if Input.is_action_just_pressed("jump"):
				velocity.y = movement_data.jumpVelocity
		#double jump add effect
		if not is_on_floor() && coyote_jump.timeout:
			if Input.is_action_just_pressed("jump") && airAction && $Health.stamina > 0:
				velocity.y = movement_data.jumpVelocity
				$Health.stamina -= 1
				airAction = false
	if is_on_floor():
		airAction = true
		newWallJump = movement_data.wallJumpSpeed

func handleWallJump():
	if !is_on_wall(): return
	if is_on_floor(): return
	
	var wallNormal = get_wall_normal()
	if !is_on_floor():
		if Input.is_action_just_pressed("ui_left") && wallNormal == Vector2.LEFT && $Health.stamina > 0:
			velocity.x = wallNormal.x * newWallJump
			velocity.y = movement_data.jumpVelocity
			newWallJump -= 50
			#$Health.stamina-=1

		if Input.is_action_just_pressed("ui_right") && wallNormal == Vector2.RIGHT && $Health.stamina > 0:
			velocity.x = wallNormal.x * newWallJump
			velocity.y = movement_data.jumpVelocity
			newWallJump -= 50
			#$Health.stamina-=1
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		

func applyAirResistance(input_axis, delta):
	if input_axis==0 && !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.airResistance * delta)

func updateAnim(input_axis):
	if(input_axis!=0) && canMove == true:
		$AnimatedSprite2D.flip_h = (input_axis < 0)
		$BATTLE.scale.x = input_axis
		$AnimationPlayer.play("run")
	else:
		if canMove == true :
			$AnimationPlayer.play("idle")
		
	if not is_on_floor():
		if velocity.y < 0:
			$AnimationPlayer.play("jump")
		if velocity.y > 0:
			$AnimationPlayer.play("fall")
	#prevents infinite fall animation
	if $AnimationPlayer.current_animation == "fall" && is_on_floor():
		canMove = true
