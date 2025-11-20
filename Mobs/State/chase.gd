# res://mobs/states/MobChase.gd
extends MobState
class_name MobChase


func physics_update(_delta: float) -> void:
	if owner_mob == null:
		return

	var m: Mob = owner_mob
	var p: Node2D = m.target
	if p == null:
		m.get_node("StateMachine").change("Idle"); return

	var to_p: Vector2 = p.global_position - m.global_position
	if to_p.length() > m.aggro_radius * 1.5:
		m.get_node("StateMachine").change("Idle"); return

	var dir: Vector2 = to_p.normalized()
	m.velocity = dir * m.chase_speed
	m.move_and_slide()
	m.play_walk_by_dir(dir)
