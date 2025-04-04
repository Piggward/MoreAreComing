class_name Enemy
extends Area2D

@export var speed: float
@export var damage: float
var turret: Turret
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
signal died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turret = get_tree().get_first_node_in_group("turret")
	collision_polygon_2d.polygon = polygon_2d.polygon
	pass # Replace with function body.

func take_damage(damage: int):
	print("I took ", damage)
	die()
	
func die():
	died.emit()
	self.queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(turret.global_position)
	self.position += Vector2(0, -speed).rotated(self.rotation + deg_to_rad(90))
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("me kill")
		die()
	pass # Replace with function body.
