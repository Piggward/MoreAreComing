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
	var arr: Array[ShootArea] = []
	arr.append(bounce)
	return arr
	
func on_hit(sa: ShootArea, enemy: Enemy):
	enemy.take_damage(damage)
	
func get_direction(turret):
	return randf_range(deg_to_rad(0), deg_to_rad(360))
	
func get_position(nozzle):
	return Vector2.ZERO
	
func on_out_of_bounds(sa: ShootArea):
	if bounces_left == 0:
		sa.terminate_self()
		return
	bounces_left -= 1 
	#sa.direction = sa.get_global_mouse_position()
	#var mouse = sa.get_global_mouse_position()
	var rand_angle = randf_range(-45, 45)
	var new_angle = deg_to_rad(180 + rand_angle)
	sa.direction += new_angle
	sa.self_rotate()
