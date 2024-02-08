extends Node
class_name Enemy

@export var maxHealth : int
@export var knockback : Vector2 =  Vector2(50,500)
@export var armourRating : int
var health

var hitDirection
signal dead

func _ready():
	health = maxHealth

var playerLeft : bool
func hit(dmg:int, dist : Vector2):
	if armourRating <= 0:
		print("broken")
		playerLeft = (dist.x < 0)
		get_parent().changeState(get_parent().STATES.HURT)
	else: armourRating -= 1
	health -= (dmg - armourRating)
	print(health)
	
	if health <=0 :
		dead.emit()

func _process(_delta):
	$"../Sprite2D".flip_h = (playerLeft)
