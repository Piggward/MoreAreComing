class_name ReloadPowerUp
extends PowerUp

@export var reload_multiplier: float = 1

func get_description():
	var percent = (1.0 - reload_multiplier) * 100
	return "Increase reload speed by " + str(percent) + " %"
	
func apply(player: Player):
	var power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
			
	player.stats.reload_speed *= reload_multiplier
