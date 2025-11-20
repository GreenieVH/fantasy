class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged()

const DIR_4 = [Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT,Vector2.UP]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player = Player
var invulnerable : bool = false

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	player  = PlayerManager.player
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
