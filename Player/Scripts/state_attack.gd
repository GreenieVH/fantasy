class_name State_Attack extends State

var attacking : bool = false
@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"
@onready var animation_player : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var attack_anim : AnimatedSprite2D = $"../../AnimatedSprite2D/AnimatedSprite2D"
@onready var hurt_box_down : HurtBox=$"../../Interactions/HurtBoxDown"
@onready var hurt_box_up : HurtBox=$"../../Interactions/HurtBoxUp"
@onready var hurt_box_side : HurtBox=$"../../Interactions/HurtBoxSide"

func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_anim.play( player.AniDirection() + "_attack")
	animation_player.animation_finished.connect(EndAttack)
	attacking = true
	var host = $"../../Interactions"
	var hb = host.current_hurtbox
	await get_tree().create_timer(0.075).timeout
	if hb:
		hb.monitoring = true
		hb.visible = true
	pass

func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box_down.monitoring = false
	hurt_box_up.monitoring = false
	hurt_box_side.monitoring = false
	pass

func Process(_delta : float) -> State:
	player.velocity = Vector2.ZERO
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:  
			return walk
	return null
	

func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
	
func EndAttack() -> void:
	attacking = false
