class_name PiercePowerUp
extends PowerUp

@export var pierce: int = 0

func apply(player: Player):
	super.apply(player)
	if not power:
		return
	power.pierce += pierce
