class_name Force
extends Power

@export var knock_back: float = 25
@export var radius: float = 800
var bounces_left: int
var start_radius: float = -1
const FORCE_SHOOT = preload("res://resources/powers/force/force.tscn")
const FORCE_AREA = preload("res://resources/debuffs/force_area.tscn")
const FORCE = preload("res://resources/powers/force/force.tscn")
const FORCE_SHOP_ICON = preload("res://resources/powers/force/force_shop_icon.tscn")

func get_texture():
	return FORCE_SHOP_ICON.instantiate()
	
func get_power_name():
	return "Forcefield"
	
func get_general_description():
	return "A massive forcefield knocking back enemies"

func get_shot_instances():
	var shoot_area: ShootArea = FORCE.instantiate()
	shoot_area.power = self
	var arr: Array[ShootArea] = []
	var force: Area2D = FORCE_AREA.instantiate()
	force.area_entered.connect(shoot_area.on_hit)
	shoot_area.add_child(force)
	arr.append(shoot_area)
	return arr
	
func on_hit(sa: ShootArea, enemy: Enemy):
	if sa.enemies_hit.has(enemy) or sa.dead:
		return
	var knock_back_node = KnockBackNode.new()
	knock_back_node.direction = (enemy.global_position - sa.global_position).normalized()
	knock_back_node.time = 0.7
	knock_back_node.knock_back_speed = knock_back
	enemy.add_child(knock_back_node)
	#enemy.take_damage(damage)
	sa.enemies_hit.append(enemy)
	
func get_position(nozzle):
	return Vector2(0, 0)
	
func travel(sa: ShootArea, delta: float):
	if start_radius == -1:
		for child in sa.get_children():
			if child is ForceArea:
				start_radius = child.real_radius()
				
	sa.scale += sa.scale * delta
	if sa.scale.x * start_radius >= radius:
		sa.terminate_self()
