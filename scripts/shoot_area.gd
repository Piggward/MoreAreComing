class_name Shoot
extends Area2D

@export var direction: float
@export var speed: int
@export var damage: int
@export var pierce: int
@export var knock_back: float
@export var player_color: Color
@onready var shoot_polygon: Polygon2D = $ShootPolygon
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
var has_hit = false
var camera: Camera
var dead = false
var enemies: Array[Enemy]
@onready var point_light_2d = $PointLight2D
@onready var particles = $Particles
@onready var trail = $Particles/Trail
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var polygon_2d = $Polygon2D
@onready var polygon_2d_2 = $Polygon2D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera")
	particles.rotation = direction - deg_to_rad(90)
	sprite_2d.rotation = direction + deg_to_rad(180)
	point_light_2d.rotation += direction - deg_to_rad(90)
	polygon_2d.color = player_color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not dead:
		self.position += Vector2(0, speed * delta).rotated(direction)
	pass

func terminate_self():
	audio_stream_player_2d.pitch_scale += randf_range(0, 0.04)
	audio_stream_player_2d.play()
	if pierce >= 0:
		return
	dead = true
	collision_shape_2d.queue_free()
	point_light_2d.visible = false
	sprite_2d.visible = false
	polygon_2d.visible = false
	polygon_2d_2.visible = false
	for child in particles.get_children():
		if child.name != "Trail":
			child.visible = false
		else:
			child.enabled = false
		child.emitting = false
	await audio_stream_player_2d.finished
	await get_tree().create_timer(4).timeout
	self.queue_free()
	

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy and (not has_hit or pierce >= 0) and not enemies.has(area):
		has_hit = true
		pierce -= 1
		enemies.append(area)
		camera.add_trauma(3)
		area.take_damage(damage, knock_back)
		terminate_self()
	pass # Replace with function body.
