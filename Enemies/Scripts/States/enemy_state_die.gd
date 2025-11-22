class_name EnemyStateDie
extends EnemyState

@export var anim_name : String = "die"
@export var free_on_anim_finished : bool = true
@export var free_delay : float = 0.0   # nếu muốn chờ thêm xíu rồi mới free

var _animation_finished: bool = false
var _timer: float = 0.0


func Init() -> void:
	# Kết nối signal từ Enemy
	enemy.enemy_die.connect(_on_enemy_die)


func Enter() -> void:
	_animation_finished = false
	_timer = 0.0

	enemy.velocity = Vector2.ZERO
	enemy.invulnerable = true

	enemy.UpdateAnimation(anim_name)

	if not enemy.animation_sprite.animation_finished.is_connected(_on_animation_finished):
		enemy.animation_sprite.animation_finished.connect(_on_animation_finished)


func Exit() -> void:
	if enemy and enemy.animation_sprite.animation_finished.is_connected(_on_animation_finished):
		enemy.animation_sprite.animation_finished.disconnect(_on_animation_finished)


func Process(delta: float) -> EnemyState:
	if _animation_finished:
		if free_on_anim_finished:
			if free_delay <= 0.0:
				enemy.queue_free()
			else:
				_timer += delta
				if _timer >= free_delay:
					enemy.queue_free()
		return null   # state cuối, không chuyển sang state khác

	return null


func Physics(_delta: float) -> EnemyState:
	return null


func _on_enemy_die() -> void:
	# khi Enemy báo là đã chết -> chuyển state sang Die
	state_machine.ChangeState(self)


func _on_animation_finished() -> void:
	_animation_finished = true
