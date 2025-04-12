class_name Enemy
extends Area2D

@export var speed: float
@export var damage: float
@export var max_health: int
var player: Player
var level: Level
var current_health: int
signal died
@onready var progress_bar = $Node2D/ProgressBar
@onready var animated_sprite_2d = $AnimatedSprite2D
const EXPLOSION_PARTICLES = preload("res://scenes/explosion_particles.tscn")
var normal_color: Color
const NAILSPARTICLES = preload("res://scenes/nailsparticles.tscn")
const SCREWSPARTICLES = preload("res://scenes/screwsparticles.tscn")
const EXPLOSION_2 = preload("res://scenes/explosion2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_bonus()
	player = get_tree().get_first_node_in_group("player")
	level = get_tree().get_first_node_in_group("level")
	progress_bar.max_value = max_health
	current_health = max_health
	progress_bar.value = current_health
	normal_color = animated_sprite_2d.self_modulate
	pass # Replace with function body.
	
func find_bonus():
	for child in get_children():
		if child.name == "TANK":
			self.speed *= 0.8
			self.max_health *= 4
			self.damage = 20
		if child.name == "SPEED":
			self.speed += clamp(self.speed * 1.5, 0.1, 1) 
			self.damage = 5

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
	#var exp = EXPLOSION_PARTICLES.instantiate()
	#exp.emitting = true
	var exp = EXPLOSION_2.instantiate()
	level.add_child(exp)
	var np = NAILSPARTICLES.instantiate()
	var sp = SCREWSPARTICLES.instantiate()
	np.emitting = true
	sp.emitting = true
	level.add_child(np)
	level.add_child(sp)
	np.global_position = self.global_position
	sp.global_position = self.global_position
	exp.global_position = self.global_position
	died.emit()
	self.queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(player.global_position)
	self.position += Vector2(0, -speed * delta).rotated(self.rotation + deg_to_rad(90))
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(self.damage)
		die()
	pass # Replace with function body.
