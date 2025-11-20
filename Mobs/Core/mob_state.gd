extends Node
class_name MobState

var owner_mob : Mob

func enter(_msg := {}): pass
func exit(): pass
func physics_update(_delta: float): pass
func handle_event(_name: String, _data := {}): pass
