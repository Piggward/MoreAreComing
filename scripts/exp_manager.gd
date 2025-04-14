class_name ExpManager
extends Node2D

@export var exp_wait_time: float
const RUMBLE_NODE = preload("res://scenes/rumble_node.tscn")
const UPGRADE_PARTICLES = preload("res://vfx/upgrade_particles.tscn")
	
func _spawn_exp(gp: Vector2, worth: int):
	var rn = RUMBLE_NODE.instantiate()
	rn.exp_worth = worth
	rn.position = gp - self.global_position
	add_child(rn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
