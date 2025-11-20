extends MobState
class_name MobWander

@export var min_t: float = 1.0
@export var max_t: float = 2.0
@export var stop_chance: float = 0.2

var dir: Vector2 = Vector2.ZERO
var t: float = 0.0
var rng := RandomNumberGenerator.new()

func enter(_msg := {}) -> void:
	rng.randomize()
	t = rng.randf_range(min_t, max_t)
	if rng.randf() < stop_chance:
		dir = Vector2.ZERO
	else:
		var dirs := [
			Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT,
			Vector2(-1,-1).normalized(), Vector2(1,-1).normalized(),
			Vector2(-1,1).normalized(), Vector2(1,1).normalized()
		]
		dir = dirs[rng.randi_range(0, dirs.size() - 1)]

func physics_update(delta: float) -> void:
	t -= delta
	if _player_in_range():
		owner_mob.get_node("StateMachine").change("Chase"); return

	owner_mob.velocity = dir * owner_mob.move_speed
	owner_mob.move_and_slide()

	if dir == Vector2.ZERO: owner_mob.play_idle()
	else: owner_mob.play_walk_by_dir(dir)

	if owner_mob.is_on_wall() or t <= 0.0:
		owner_mob.get_node("StateMachine").change("Idle")

func _player_in_range() -> bool:
	var m: Mob = owner_mob
	var p: Node2D = m.target
	return p != null and m.global_position.distance_to(p.global_position) <= m.aggro_radius
