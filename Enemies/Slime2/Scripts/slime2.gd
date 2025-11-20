extends Mob
class_name Slime2

func _ready() -> void:
	# nếu bạn dùng tên anim có typo:
	anim_down_idle = "down_idle_silme2"
	anim_side_idle = "side_idle_slime2"
	anim_down_walk = "down_walk_slime2"
	anim_side_walk = "side_walk_slime2"
	anim_up_walk = "up_walk_slime2"
	anim_up_idle = "up_idle_slime2"
	# phần còn lại dùng mặc định từ Mob
	super._ready()
