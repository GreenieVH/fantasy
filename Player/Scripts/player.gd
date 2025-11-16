class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2  = Vector2.ZERO


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite := $Sprite2D    
@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready():
	state_machine.Initialize(self)
	pass

func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	# chọn hướng chính theo giá trị lớn hơn (x hay y) để tránh nhầm khi nhấn chéo
	if direction == Vector2.ZERO:
		return false

	var new_dir: Vector2 = cardinal_direction
	if direction.y == 0:
		new_dir = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	elif direction.x == 0:
		new_dir = Vector2.DOWN if direction.y > 0 else Vector2.UP

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1

	return true


func UpdateAnimation(state : String) -> void:
	var anim_name := state + "_" + AniDirection()

	if animation_player and animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
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
