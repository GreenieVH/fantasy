# DamagePopup.gd
extends Node2D

@export var float_speed: float = 40.0   # tốc độ bay lên
@export var lifetime: float = 0.6       # sống trong bao lâu (giây)

var _time := 0.0

@onready var label: Label = $Label

func show_damage(amount: int, world_position: Vector2) -> void:
	# đặt số damage
	label.text = "-" + str(amount)
	# đặt vị trí xuất hiện
	global_position = world_position + Vector2(0, -16)  # hơi trên đầu quái

func _process(delta: float) -> void:
	_time += delta
	# bay lên
	position.y -= float_speed * delta
	# mờ dần
	var t := _time / lifetime
	modulate.a = 1.0 - clamp(t, 0.0, 1.0)

	if _time >= lifetime:
		queue_free()
