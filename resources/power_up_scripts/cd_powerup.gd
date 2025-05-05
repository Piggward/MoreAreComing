class_name CdPowerUp
extends PowerUp

@export var cd_multiplier: float 
#var starting_power: Power

func get_description():
	var percent = (1.0 - cd_multiplier) * 100
	return "Increase frequency by " + str(percent) + " %"

func apply(player: Player):
	var power: Power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
			
	power.cool_down *= cd_multiplier
