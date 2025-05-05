class_name Power
extends Resource

const TOWER_DEFENSE_TILE_250 = preload("res://art/towerDefense_tile250.png")
const SHOOT_AREA = preload("res://scenes/shoot_area.tscn")
@export var damage: int
@export var cool_down: float
@export var speed: float
@export var instances: int = 1
var timer: Timer
var texture: Texture = TOWER_DEFENSE_TILE_250

func get_texture():
	pass
	
func get_power_name():
	pass
	
func get_general_description():
	pass

func get_shot_instances():
	var ar: Array[ShootArea] = []
	var sa = SHOOT_AREA.instantiate()
	sa.power = self
	ar.append(sa)
	return ar
	
func on_hit(sa: ShootArea, enemy: Enemy):
	if sa.enemies_hit.has(enemy):
		return
	enemy.position -= Vector2(0, 3).rotated(enemy.rotation - deg_to_rad(90))
	enemy.take_damage(damage)
	sa.terminate_self()
	sa.enemies_hit.append(enemy)

func travel(sa: ShootArea, delta: float):
	sa.position += Vector2(0, speed * delta).rotated(sa.direction)
	pass
	
func on_out_of_bounds(sa: ShootArea):
	sa.queue_free()
	
func get_direction(turret):
	return turret.rotation - deg_to_rad(90)
	
func get_position(nozzle):
	return nozzle.position
