class_name MagnetSizePowerUp
extends PowerUp

@export var magnet_size_multiplier: float

func get_description():
	var percent = (magnet_size_multiplier - 1.0) * 100
	return "Increase magnet size by " + str(percent) + " %"

func apply(player: Player):
	player.update_magnet_size(magnet_size_multiplier)
