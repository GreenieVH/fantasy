class_name EnemyStateHurt extends EnemyState

@export var anim_name : String = "hurt"
@export var knockback_speed : float = 500.0
@export var decelerate_speed : float = 10.0
@export_category("AI")
@export var next_state : EnemyState

var _diretion : Vector2
var _animation_finished= false

func Init() -> void:
	print("Hurt Init")
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass
	
func Enter() -> void:
	_animation_finished = false
	enemy.invulnerable = true
	_diretion = enemy.global_position.direction_to(enemy.player.global_position)
	_diretion = - _diretion
	enemy.SetDirection(_diretion)
	enemy.velocity =_diretion * knockback_speed
	enemy.UpdateAnimation(anim_name)
	enemy.animation_sprite.animation_finished.connect( _on_animation_finished)
	pass

func Exit() -> void:
	enemy.invulnerable = false
	enemy.animation_sprite.animation_finished.disconnect( _on_animation_finished)
	pass
	
func Process(_delta : float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func Physics(_delta: float) -> EnemyState:
	return null

func _on_enemy_damaged() -> void:
	state_machine.ChangeState(self)

func _on_animation_finished() -> void:
	_animation_finished = true
