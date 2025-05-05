class_name AoePowerUp
extends PowerUp

@export var aoe_multiplier: float = 1.0

func get_description():
	var percent = (aoe_multiplier - 1.0) * 100
	return "Increase aoe by " + str(percent) + " %"
	
func apply(player: Player):
	var power: Power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
			
	power.radius *= aoe_multiplier
