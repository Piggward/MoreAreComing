class_name PowerUp
extends Resource

@export var title: String
@export var title_color: Color = Color.WHITE
@export var power_up_description: String

@export var power_type_name: String
@export var shoot_speed: float = 1
@export var shot_scale: float = 1
@export var damage: float = 1
@export var shoot_cd: float = 1
@export var turn_rate: float = 1
@export var mag_size: int = 0
@export var reload_speed: float = 1
@export var aoe: float = 1
@export var pierce: int = 0
@export var knock_back: float = 0
@export var has_automatic_shooting: bool = false
@export var has_automatic_reload: bool = false


func apply(player: Player):
	for power in player.powers:
		if power is ClassDB.get_class(power_type_name):
			power.upgrade()
