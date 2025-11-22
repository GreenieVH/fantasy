class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged()
signal enemy_die()

const DIR_4 = [Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT,Vector2.UP]

@export var max_hp : int = 3
var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player = Player
var invulnerable : bool = false

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var hit_box : HitBox = $HitBox
@onready var hp_bar: ProgressBar = $HPBar

const DamagePopupScene := preload("res://UI/DamagePopup/DamagePopup.tscn")
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = max_hp
	if hp_bar:
		hp_bar.min_value = 0
		hp_bar.max_value = max_hp
		hp_bar.value = hp
		hp_bar.visible = true
	
	state_machine.Initialize(self)
	player  = PlayerManager.player
	hit_box.Damaged.connect(_take_damage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
func _physics_process(_delta) -> void:
	move_and_slide()
	

func SetDirection(_new_direction: Vector2) -> bool:
	direction = _new_direction
	
	if direction == Vector2.ZERO:
		return false

	var new_dir: Vector2 = cardinal_direction

	# Ưu tiên trục X để tránh hướng xấu khi đi chéo
	if direction.x != 0:
		new_dir = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		# Chỉ chọn up/down khi KHÔNG có chuyển động theo X
		new_dir = Vector2.DOWN if direction.y > 0 else Vector2.UP

	# Nếu hướng không thay đổi thì return false
	if new_dir == cardinal_direction:
		return false

	# Cập nhật hướng chính
	cardinal_direction = new_dir
	#DirectionChange.emit(new_dir)
	# Flip sprite theo trái/phải
	if cardinal_direction == Vector2.LEFT:
		animation_sprite.flip_h = true
	elif cardinal_direction == Vector2.RIGHT:
		animation_sprite.flip_h = false

	return true

func UpdateAnimation(state : String) -> void:
	var anim_name :=  AniDirection() + "_" + state

	if animation_sprite.sprite_frames and animation_sprite.sprite_frames.has_animation(anim_name):
		
		animation_sprite.play(anim_name)
		return
		
func AniDirection() -> String:
	# chỉ trả "down", "up" hoặc "side"
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		# left/right đều dùng "side" (sprite được flip để phân biệt)
		return "side"

func _take_damage(damage : int)  -> void:
	if invulnerable:
		return
	if damage > 0:
		_show_damage_popup(damage)
	hp -= damage
	if hp < 0:
		hp = 0

	if hp_bar:
		hp_bar.value = hp

	if hp <= 0:
		enemy_die.emit()
		return

	enemy_damaged.emit()
	
func _init_hp_bar() -> void:
	if hp_bar:
		hp_bar.min_value = 0
		hp_bar.max_value = max_hp
		hp_bar.value = hp
		# Nếu muốn chỉ hiện khi mất máu:
		hp_bar.visible = hp < max_hp

func _show_damage_popup(damage: int) -> void:
	var popup := DamagePopupScene.instantiate()
	# Thêm vào cùng parent với Enemy, để nó bay trong world 2D
	get_parent().add_child(popup)
	popup.show_damage(damage, global_position)
