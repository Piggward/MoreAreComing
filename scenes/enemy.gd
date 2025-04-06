class_name Enemy
extends Area2D

@export var speed: float
@export var damage: float
@export var max_health: int
var turret: Turret
var current_health: int
signal died
@onready var progress_bar = $Node2D/ProgressBar
@onready var animated_sprite_2d = $AnimatedSprite2D
const EXPLOSION_PARTICLES = preload("res://scenes/explosion_particles.tscn")
var normal_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_bonus()
	turret = get_tree().get_first_node_in_group("turret")
	progress_bar.max_value = max_health
	current_health = max_health
	progress_bar.value = current_health
	normal_color = animated_sprite_2d.self_modulate
	pass # Replace with function body.
	
func find_bonus():
	for child in get_children():
		if child.name == "TANK":
			self.speed *= 0.6
			self.max_health *= 4
		if child.name == "SPEED":
			self.speed += clamp(self.speed * 0.75, 0.6, 1.6) 

func take_damage(damage: int, knock_back: float):
	current_health -= damage
	progress_bar.value = current_health
	self.position -= Vector2(0, knock_back).rotated(self.rotation - deg_to_rad(90))
	if current_health <= 0:
		die()
	animated_sprite_2d.self_modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	animated_sprite_2d.self_modulate = normal_color
	
func die():
	died.emit()
	var exp = EXPLOSION_PARTICLES.instantiate()
	exp.emitting = true
	get_parent().add_child(exp)
	exp.global_position = self.global_position
	self.queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(turret.global_position)
	self.position += Vector2(0, -speed).rotated(self.rotation + deg_to_rad(90))
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(self.damage)
		die()
	pass # Replace with function body.
