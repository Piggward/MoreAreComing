class_name Rocket
extends Power

const ROCKET = preload("res://scenes/rocket.tscn")
const AOE = preload("res://scenes/aoe.tscn")

@export var radius: float = 5

func get_shot_instance():
	var rocket = ROCKET.instantiate()
	rocket.power = self
	var aoe = AOE.instantiate()
	aoe.radius = radius
	rocket.add_child(aoe)
	return rocket
	
func on_hit(sa: ShootArea, enemy: Enemy):
	var aoe: Area2D
	for child in sa.get_children():
		if child is Aoe:
			aoe = child
			break
	if not aoe:
		sa.terminate_self()
		return
	for area in aoe.get_overlapping_areas():
		if area is Enemy:
			area.take_damage(self.damage)
	sa.terminate_self()
