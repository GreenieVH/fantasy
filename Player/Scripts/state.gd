# res://player/state/state.gd
class_name State extends Node

# Reference tới Player
static var player: Player

func _ready():
	pass

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Process(_delta : float) -> State:
	return null
	

func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
