extends CharacterBody2D
class_name Mob

@export var move_speed: float = 40.0
@export var chase_speed: float = 60.0
@export var aggro_radius: float = 120.0
@export var player_group_name: String = "Player"

# Cho phép mỗi mob cấu hình tên animation của nó
@export var anim_side_idle: String = " "
@export var anim_side_walk: String = " "
@export var anim_up_idle: String   = " "
@export var anim_up_walk: String   = " "
@export var anim_down_idle: String = " "
@export var anim_down_walk: String = " "

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: MobStateMachine = $StateMachine

var target: Node2D = null
var last_facing: String = "down" # "down"|"up"|"side"

func _ready() -> void:
	var players := get_tree().get_nodes_in_group(player_group_name)
	if players.size() > 0:
		target = players[0] as Node2D

func _physics_process(delta: float) -> void:
	fsm.physics_update(delta)

# ---------- helpers cho state ----------
func play_idle() -> void:
	match last_facing:
		"side": _play(anim_side_idle)
		"up":   _play_first([anim_up_idle, anim_down_idle]) # fallback
		_:      _play_first([anim_down_idle, anim_side_idle])

func play_walk_by_dir(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		last_facing = "side"
		anim.flip_h = dir.x < 0
		_play(anim_side_walk)
	elif dir.y < 0:
		last_facing = "up"
		_play(anim_up_walk)
	else:
		last_facing = "down"
		_play(anim_down_walk)

func _play(name: String) -> void:
	if anim and anim.sprite_frames and anim.sprite_frames.has_animation(name):
		anim.play(name)

func _play_first(names: Array[String]) -> void:
	for n in names:
		if anim and anim.sprite_frames and anim.sprite_frames.has_animation(n):
			anim.play(n); return
