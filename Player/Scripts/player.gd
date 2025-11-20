class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2  = Vector2.ZERO


@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
signal DirectionChange (new_direction : Vector2)
func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	pass

func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	# Nếu không di chuyển thì không đổi hướng
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
	DirectionChange.emit(new_dir)
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
