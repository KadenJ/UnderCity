extends Node2D
class_name Health

@export var maxHealth = 5
var health
@export var maxStamina = 6
var stamina

# Called when the node enters the scene tree for the first time.
func _ready():
	health = maxHealth
	stamina = maxStamina


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var loadingStamina = false
	if stamina != maxStamina:
		if loadingStamina == false:
			loadingStamina = true
			await get_tree().create_timer(1).timeout
			stamina += 1
			loadingStamina = true
