class_name InstancePowerUp
extends PowerUp

#var starting_power: Power
@export var instances: int = 0

func get_description():
	return "Adds " + str(instances) + " more instances"

func apply(player: Player):
	var power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
			
	power.instances += instances
