class_name PowerTree
extends Resource

@export var powerups: Array[PowerUp]

func get_random_powerup():
	var rand = randi_range(0, powerups.size() - 1)
	return powerups[rand]
