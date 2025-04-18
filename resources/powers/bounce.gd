class_name Bounce
extends Power

const BOUNCE = preload("res://scenes/bounce.tscn")

@export var bounces: int = 2
var bounces_left: int

func get_shot_instances():
	var bounce = BOUNCE.instantiate()
	var p: Bounce = self.duplicate()
	p.bounces_left = bounces
	bounce.power = p
	print(bounce.power.bounces_left)
	var arr: Array[ShootArea] = []
	arr.append(bounce)
	return arr
	
func on_hit(sa: ShootArea, enemy: Enemy):
	enemy.take_damage(damage)
	if bounces_left > 0:
		bounces_left -= 1 
		#sa.direction = sa.get_global_mouse_position()
		var mouse = sa.get_global_mouse_position()
		sa.direction = sa.rotation + sa.get_angle_to(mouse) - deg_to_rad(90)
		sa.self_rotate()
	else:
		sa.terminate_self()
	
func get_direction(turret):
	var mouse = turret.get_global_mouse_position()
	return turret.rotation + turret.get_angle_to(mouse) - deg_to_rad(90)
	
func get_position(nozzle):
	return -nozzle.position - nozzle.position
