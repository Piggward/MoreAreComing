class_name PiercePowerUp
extends PowerUp

const PIERCE_STARTING = preload("res://resources/start_power/pierce_starting.tres")

@export var pierce: int = 0

func set_power():
	starting_power = PIERCE_STARTING

func apply(player: Player):
	if not starting_power:
		set_power()
	super.apply(player)
	if not power:
		return
	power.pierce += pierce
