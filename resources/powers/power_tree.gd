class_name PowerTree
extends Resource

@export var powerups: Array[PowerUp]
@export var starting_power: Power

func initialize_powerups():
	for power in powerups:
		power.starting_power = starting_power

func get_random_powerup():
	var rand = randi_range(0, powerups.size() - 1)
	return powerups[rand]
