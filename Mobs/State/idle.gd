extends MobState
class_name MobIdle

@export var idle_time: float = 0.8
var t: float = 0.0

func enter(_msg := {}) -> void:
	t = idle_time
	owner_mob.play_idle()

func physics_update(delta: float) -> void:
	t -= delta
	if _player_in_range():
		owner_mob.get_node("StateMachine").change("Chase")
	elif t <= 0.0:
		owner_mob.get_node("StateMachine").change("Wander")

func _player_in_range() -> bool:
	var m: Mob = owner_mob
	var p: Node2D = m.target
	return p != null and m.global_position.distance_to(p.global_position) <= m.aggro_radius
