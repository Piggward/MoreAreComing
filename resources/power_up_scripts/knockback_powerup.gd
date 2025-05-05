class_name KnockBackPowerUp
extends PowerUp

@export var knockback_multipler: float = 1

func get_description():
	var percent = (knockback_multipler - 1.0) * 100
	return "Increase knockback by " + str(percent) + " %"

func apply(player: Player):
	var power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
			
	power.knock_back *= knockback_multipler
