extends Mob
class_name Slime1

func _ready() -> void:
	# nếu bạn dùng tên anim có typo:
	anim_down_idle = "down_idle_silme1"
	anim_side_idle = "side_idle_slime1"
	anim_down_walk = "down_walk_slime1"
	anim_side_walk = "side_walk_slime1"
	anim_up_walk = "up_walk_slime1"
	anim_up_idle = "up_idle_slime1"
	# phần còn lại dùng mặc định từ Mob
	super._ready()
