class_name PlayerInteractionHost extends Node2D

@onready var player : Player = $".."
var current_hurtbox : HurtBox =  null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.DirectionChange.connect(UpdateDirection)
	pass # Replace with function body.

func UpdateDirection(new_direction : Vector2) -> void:
	$HurtBoxDown.visible = false
	$HurtBoxUp.visible = false
	$HurtBoxSide.visible = false

	match new_direction:
		Vector2.DOWN:
			current_hurtbox = $HurtBoxDown
		Vector2.UP:
			current_hurtbox = $HurtBoxUp
		Vector2.LEFT:
			current_hurtbox = $HurtBoxSide
			$HurtBoxSide.rotation_degrees = 180
		Vector2.RIGHT:
			current_hurtbox = $HurtBoxSide
			$HurtBoxSide.rotation_degrees = 0
		_:
			current_hurtbox = $HurtBoxDown
	current_hurtbox.visible = true
	pass
