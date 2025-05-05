class_name MagSizePowerUp
extends PowerUp

@export var magsize: int

func get_description():
	return "Increase magsize by " + str(magsize)

func apply(player: Player):
	var power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
			
	power.mag_size += magsize
