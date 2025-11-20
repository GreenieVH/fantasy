class_name State_Run extends State

@export var move_speed : float = 350.0
@onready var idle : State = $"../Idle"
@onready var attack : State = $"../Attack"
func Enter() -> void:
	player.UpdateAnimation("run")
	pass

func Exit() -> void:
	pass

func Process(_delta : float) -> State:
	# Nếu không di chuyển → về trạng thái idle
	if player.direction == Vector2.ZERO:
		return idle
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("run")
	return null
	

func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
