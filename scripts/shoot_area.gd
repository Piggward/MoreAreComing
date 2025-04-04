class_name Shoot
extends Area2D

@export var direction: float
@export var speed: int
@export var damage: int
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var shoot_polygon: Polygon2D = $ShootPolygon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_polygon_2d.polygon = shoot_polygon.polygon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += Vector2(0, speed).rotated(direction)
	pass


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		print("I hit!")
		area.take_damage(damage)
		self.queue_free()
	pass # Replace with function body.
