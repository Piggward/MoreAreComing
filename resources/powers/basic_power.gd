class_name BasicPower
extends Power

@export var shoot_ready: bool = true
@export var shots_left: int = 10
@export var automatic_reload: bool = false
@export var automatic_shooting: bool = false
@export var mag_size: int = 10

func create_timer():
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(func(): shoot_ready = true)
	
func can_shoot():
	return shoot_ready and shots_left > 0
	
func on_shoot():
	shoot_ready = false
	shots_left -= 1
	timer.start(cool_down)
