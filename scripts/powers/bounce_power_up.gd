class_name BouncePowerUp
extends PowerUp

@export var bounce: int = 0
const BOUNCE_STARTING = preload("res://resources/start_power/bounce_starting.tres")

func set_power():
	starting_power = BOUNCE_STARTING

func apply(player: Player):
	if not starting_power:
		set_power()
	super.apply(player)
	
	if not power:
		return
	power.bounces += bounce
