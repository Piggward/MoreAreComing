class_name ForceArea
extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

func real_radius():
	return collision_shape_2d.shape.radius
