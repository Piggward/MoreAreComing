class_name PowerUp
extends Resource

var starting_power: Power

func get_description():
	pass

func apply(player: Player):
	var power: Power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
