class_name PowerUp
extends Resource

@export var title: String
@export var title_color: Color = Color.WHITE
@export var power_up_description: String
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
	player.shoot_speed *= shoot_speed
	player.damage *= damage
	player.shoot_cd *= shoot_cd
	player.turn_rate *= turn_rate
	player.mag_size += mag_size
	player.reload_speed *= reload_speed
	player.pierce += pierce
	player.knock_back += knock_back
	player.has_automatic_reload = has_automatic_reload || player.has_automatic_reload
	player.has_automatic_shooting = has_automatic_shooting || player.has_automatic_shooting
	player.shot_scale *= shot_scale
	if damage > 1:
		var turret = player.get_tree().get_first_node_in_group("turret")
		turret.scale = Vector2(1 + (damage / 10) * 0.75, 1 + (damage / 10) * 0.75)
	player.update_attributes()
