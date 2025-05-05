class_name BouncePowerUp
extends PowerUp

@export var bounces: int = 0

func get_description():
	return "Add " + str(bounces) + " more bounce(s)."
	pass

func apply(player: Player):
	var power: Power = player.get_power(starting_power.get_power_name())
	if not power:
		player.add_power(starting_power)
		return
			
	power.bounces += bounces
