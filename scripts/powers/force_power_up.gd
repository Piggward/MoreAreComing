class_name ForcePowerUp
extends PowerUp

@export var knock_back: float = 0

const FORCE_STARTING = preload("res://resources/start_power/force_starting.tres")

func set_power():
	starting_power = FORCE_STARTING

func apply(player: Player):
	if not starting_power:
		set_power()
	super.apply(player)
	if not power:
		return
	power.knock_back += knock_back
