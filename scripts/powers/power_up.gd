class_name PowerUp
extends Resource

@export var title: String
@export var title_color: Color = Color.WHITE
@export var power_up_description: String

@export var shoot_speed: float = 0
@export var damage: float = 0
@export var shoot_cd: float = 0
@export var instances: float = 0
const TOWER_DEFENSE_TILE_250 = preload("res://art/towerDefense_tile250.png")
var starting_power: Power
var power: Power
var texture: Texture = TOWER_DEFENSE_TILE_250


func apply(player: Player):
	var find_power = player.powers.filter(func(a): return a.power_name == starting_power.power_name)
	if not find_power or find_power.is_empty():
		player.add_power(starting_power)
		return
	else:
		power = find_power[0]
	power.speed += shoot_speed
	power.damage += damage
	power.cool_down -= shoot_cd
	power.instances += instances
