class_name Power
extends Resource

const SHOOT_AREA = preload("res://scenes/shoot_area.tscn")
@export var damage: int
@export var cool_down: float
@export var speed: float
var timer: Timer

func get_shot_instance():
	var sa = SHOOT_AREA.instantiate()
	sa.power = self
	return sa
	
func on_hit(sa: ShootArea, enemy: Enemy):
	enemy.take_damage(damage)
	sa.terminate_self()

func travel(sa: ShootArea, delta: float):
	sa.position += Vector2(0, speed * delta).rotated(sa.direction)
	pass
