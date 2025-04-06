class_name Shoot
extends Area2D

@export var direction: float
@export var speed: int
@export var damage: int
@export var pierce: int
@export var knock_back: float
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var shoot_polygon: Polygon2D = $ShootPolygon
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
var has_hit = false
var camera: Camera
var dead = false
var enemies: Array[Enemy]
@onready var point_light_2d = $PointLight2D
@onready var gpu_particles_2d = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_polygon_2d.polygon = shoot_polygon.polygon
	camera = get_tree().get_first_node_in_group("camera")
	self.scale *= damage / 10
	await get_tree().create_timer(10).timeout
	self.queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not dead:
		self.position += Vector2(0, speed).rotated(direction)
	pass

func terminate_self():
	audio_stream_player_2d.pitch_scale += randf_range(0, 0.04)
	audio_stream_player_2d.play()
	if pierce >= 0:
		return
	dead = true
	gpu_particles_2d.emitting = false
	collision_polygon_2d.queue_free()
	point_light_2d.visible = false
	shoot_polygon.visible = false
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
