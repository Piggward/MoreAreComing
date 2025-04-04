class_name Player
extends CharacterBody2D

@onready var turret: Turret = $".."
@export var shoot_speed: float
@export var damage: float
@export var turn_rate: float
@export var mag_size: int
@export var reload_speed: float
@export var shoot_cd: float
@export var aoe: float
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $"../Polygon2D"

func _ready():
	collision_polygon_2d.polygon = polygon_2d.polygon
	
func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("left_click"):
		turret.shoot()

	move_and_slide()
