extends Node
@export var speed : float
var acceleration = 600
var friction = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move(pos, delta):
	var direction
	if pos.x < 0: direction = -1
	else: direction = 1
	get_parent().velocity.x = move_toward(get_parent().velocity.x, speed * direction, acceleration * delta)
	
	if get_parent().is_on_floor():
		get_parent().velocity.x = move_toward(get_parent().velocity.x, 0, friction * delta)
