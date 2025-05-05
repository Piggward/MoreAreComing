class_name Pierce
extends Power

@export var pierce: int = 3
var pierces_left: int
var number: int = 1
const PIERCE = preload("res://resources/powers/pierce/pierce.tscn")
const PIERCE_SHOP_IMAGE = preload("res://resources/powers/pierce/pierce_shop_image.tscn")

func get_texture():
	return PIERCE_SHOP_IMAGE.instantiate()
	
func get_power_name():
	return "Spikes"
	
func get_general_description():
	return "Sharp spikes emitting with high frequency"
	

func get_shot_instances():
	var arr: Array[ShootArea] = []
	for i in instances:
		var shoot_area: ShootArea = PIERCE.instantiate()
		var p = self.duplicate()
		p.number = i
		p.pierces_left = pierce
		shoot_area.power = p
		arr.append(shoot_area)
	return arr
	
func on_hit(sa: ShootArea, enemy: Enemy):
	if sa.enemies_hit.has(enemy):
		return
	var direction = (enemy.global_position - sa.global_position).normalized()
	enemy.take_damage(damage)
	if not sa.enemies_hit.has(enemy):
		sa.enemies_hit.append(enemy)
	
func get_position(nozzle):
	return nozzle.position.rotated(deg_to_rad(360 / instances * number) - 45)
	
func get_direction(turret):
	return turret.rotation + deg_to_rad((360 / instances * (number - 1)) - 45 )
	
#func travel(sa: ShootArea, delta: float):
	#if start_radius == -1:
		#for child in sa.get_children():
			#if child is ForceArea:
				#start_radius = child.real_radius()
	#sa.scale *= Vector2(1.016, 1.016)
	#if sa.scale.x * start_radius >= radius:
		#sa.terminate_self()
