extends CharacterBody2D

enum STATES {IDLE, MOVE, HURT, DEAD}
var currentState : STATES
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#@export var knockback : Vector2 = Vector2(100,0)

var playerPos

func _ready():
	currentState = STATES.MOVE

func _physics_process(delta):
	var playerGroup = get_tree().get_nodes_in_group("player")
	if playerGroup.size() > 0:
		playerPos = to_local(playerGroup[0].position) 
	
	match currentState:
		STATES.IDLE:
			changeState(STATES.MOVE)
		STATES.MOVE:
			movement(playerPos, delta)
		STATES.DEAD:
			queue_free()
		STATES.HURT: #does knockback and invincibility for 
			velocity = Vector2.ZERO
			#play hurt frame
			#on anim finish, cahnge states
			print("hurt")
			changeState(STATES.IDLE)
	
	
	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func movement(pos, delta):
	var moveEnemy = get_node("Movement")
	moveEnemy.move(pos, delta)

func changeState(newState : STATES):
	currentState = newState

func _on_enemy_health_dead():
	changeState(STATES.DEAD)


