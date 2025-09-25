class_name MagnetSpeedPowerUp
extends PowerUp

@export var magnet_speed_multiplier: float

func get_description():
	var percent = (magnet_speed_multiplier - 1.0) * 100
	return "Increase magnet speed by " + str(percent) + " %"

func apply(player: Player):
	player.update_magnet_speed(magnet_speed_multiplier)
