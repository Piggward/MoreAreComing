class_name ExpManager
extends Node2D

@export var exp_wait_time: float
const RUMBLE_AREA = preload("res://scenes/rumble_area.tscn")

func _spawn_exp(gp: Vector2, worth: int):
	var rn = RUMBLE_AREA.instantiate()
	rn.exp_worth = worth
	rn.position = gp - self.global_position
	add_child(rn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
