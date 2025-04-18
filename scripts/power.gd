class_name Power
extends Resource

const SHOOT_AREA = preload("res://scenes/shoot_area.tscn")
@export var damage: int
@export var cool_down: float
@export var speed: float
@export var instances: int = 1
var timer: Timer

func get_shot_instances():
	var ar: Array[ShootArea] = []
	var sa = SHOOT_AREA.instantiate()
	sa.power = self
	ar.append(sa)
	return ar
	
func on_hit(sa: ShootArea, enemy: Enemy):
	if sa.enemies_hit.has(enemy):
		return
	enemy.position -= Vector2(0, 10).rotated(enemy.rotation - deg_to_rad(90))
	enemy.take_damage(damage)
	sa.terminate_self()
	sa.enemies_hit.append(enemy)

func travel(sa: ShootArea, delta: float):
	sa.position += Vector2(0, speed * delta).rotated(sa.direction)
	pass
	
func get_direction(turret):
	return turret.rotation - deg_to_rad(90)
	
func get_position(nozzle):
	return nozzle.position
