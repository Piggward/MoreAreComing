class_name Aoe
extends Area2D

@export var radius: float
@onready var aoe_collision: CollisionShape2D = $AoeCollision

func _ready():
	aoe_collision.shape.radius = radius
