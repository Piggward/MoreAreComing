class_name BasicPower
extends Power

@export var shoot_ready: bool = true
@export var shots_left: int = 10
@export var automatic_reload: bool = false
@export var automatic_shooting: bool = false
@export var mag_size: int = 10
const TURRET_SHOP_ICON = preload("res://resources/powers/basic_power/turret_shop_icon.tscn")

func get_power_name():
	return "Turret bullets"
	
func get_general_description():
	return ""
	
func get_texture():
	return TURRET_SHOP_ICON.instantiate()

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
