extends Node
class_name Enemy

@export var maxHealth:int
var health
signal dead

func _ready():
	health = maxHealth

func hit(dmg:int):
	health -= dmg
	print(health)
	if health <= 0:
		get_parent().queue_free()
