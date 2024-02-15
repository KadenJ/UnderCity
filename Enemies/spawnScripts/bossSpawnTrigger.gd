extends Area2D
@export var boss = preload("res://Enemies/dummy.tscn")

var isDone = false
func _process(delta):
	if area_entered && isDone == false:
		add_child(boss.instantiate())
		isDone = true


