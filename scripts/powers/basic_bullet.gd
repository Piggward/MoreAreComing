class_name BasicBulletPowerUp
extends PowerUp

@export var mag_size: int = 0
@export var has_automatic_shooting: bool = false
@export var has_automatic_reload: bool = false

const BASIC_POWER_STARTING = preload("res://resources/start_power/basic_power_starting.tres")

func apply(player: Player):
	power = player.basic_power
	power.speed += shoot_speed
	power.damage += damage
	power.cool_down -= shoot_cd
	power.mag_size += mag_size
	power.automatic_shooting = power.automatic_shooting || has_automatic_shooting
	power.automatic_reload = power.automatic_reload || has_automatic_reload
