class_name DmgPowerUp
extends PowerUp

#var starting_power: Power
@export var damage_multiplier: float = 1.0

func get_description():
	var percent = (damage_multiplier - 1.0) * 100
	return "Increase damage by " + str(percent) + " %"

func apply(player: Player):
	var power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
			
	power.damage *= damage_multiplier
