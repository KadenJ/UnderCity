extends Area2D
@onready var animation_player = $"../../AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var followUp = false
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		if $betweenAttacks.is_stopped():
			$"../..".canMove = false
			$betweenAttacks.start(.6)
			animation_player.play("attack1")
		else:
			followUp = true
		

func _on_animation_player_animation_finished(anim_name):
	$"../..".canMove = true
	if anim_name == "attack1":
		if $betweenAttacks.is_stopped():
			pass
		else:
			if followUp:
				$"../..".canMove = false
				$betweenAttacks.start(1)
				$"../../AnimationPlayer".play("attack2")
				followUp = false
	if anim_name == "attack2":
		if $betweenAttacks.is_stopped():
			pass
		else:
			if followUp:
				$"../..".canMove = false
				$"../../AnimationPlayer".play("attack3")
				$betweenAttacks.stop()
				followUp = false
