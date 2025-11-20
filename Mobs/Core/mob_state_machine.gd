# res://mobs/core/MobStateMachine.gd
extends Node
class_name MobStateMachine

var current: MobState
var states := {}

func _ready() -> void:
	# Tự thu thập các state là con
	var mob := get_parent()
	for child in get_children():
		if child is MobState:
			states[child.name] = child
			child.owner_mob = mob
	change("Idle")

func change(name: String, msg := {}) -> void:
	if current: current.exit()
	current = states.get(name)
	if current: current.enter(msg)

func physics_update(delta: float) -> void:
	if current: current.physics_update(delta)

func handle_event(name: String, data := {}) -> void:
	if current: current.handle_event(name, data)
