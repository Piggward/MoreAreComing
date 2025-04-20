class_name RocketPowerUp
extends PowerUp

@export var radius: float = 0

const ROCKET_STARTING = preload("res://resources/start_power/rocket_starting.tres")

func set_power():
	starting_power = ROCKET_STARTING

func apply(player: Player):
	if not starting_power:
		set_power()
	super.apply(player)
	if not power:
		return
	power.radius += radius
