class_name Enemy
extends Area2D

const NAILSPARTICLES = preload("res://scenes/nailsparticles.tscn")
const SCREWSPARTICLES = preload("res://scenes/screwsparticles.tscn")
const EXPLOSION_2 = preload("res://scenes/explosion2.tscn")
const EXPLOSION_PARTICLES = preload("res://scenes/explosion_particles.tscn")
const DAMAGE_LABEL = preload("res://scenes/enemies/damage_label.tscn")

@export var speed: float
@export var damage: float
@export var max_health: int
@export var main_color: Color
@export var wheel_color_1: Color
@export var wheel_color_2: Color
@export var accent_color: Color
@export var exp: int = 1
@export var exp_chance: float = 0.4
@export var part_of_horde: bool

@onready var progress_bar = $Node2D/ProgressBar
@onready var animated_sprite_2d = $AnimatedSprite2D

var player: Player
var level: Level
var current_health: int
var normal_scale = 0.3
var normal_color: Color
var dead: bool = false
var taking_damage: bool = false

signal died(enemy: Enemy)

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
			self.speed *= 2.5
			self.damage = 5
			self.max_health *= 0.75

func take_damage(damage: int):
	current_health -= damage
	progress_bar.value = current_health
	progress_bar.visible = true
	var damage_label = DAMAGE_LABEL.instantiate()
	damage_label.damage = damage
	get_tree().root.add_child(damage_label)
	damage_label.global_position = progress_bar.global_position
	if current_health <= 0:
		die()
	if taking_damage:
		return
	taking_damage = true
	var m = animated_sprite_2d.material.duplicate(true)
	animated_sprite_2d.material = null
	animated_sprite_2d.self_modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	animated_sprite_2d.material = m
	animated_sprite_2d.self_modulate = normal_color
	taking_damage = false
	
func die():
	dead = true
	spawn_all_particles()
	died.emit(self)
	self.queue_free()
	
func spawn_all_particles():
	spawn_particles(EXPLOSION_2.instantiate())
	spawn_junk()
	
func spawn_junk():
	var x = NAILSPARTICLES.instantiate()
	x.junktype = Junk.JUNKTYPE.SCREW
	x.self_modulate = wheel_color_1
	var y = NAILSPARTICLES.instantiate()
	y.junktype = Junk.JUNKTYPE.NAIL
	y.self_modulate = wheel_color_2
	var z = NAILSPARTICLES.instantiate()
	z.junktype = Junk.JUNKTYPE.ROUND
	z.self_modulate = wheel_color_1
	spawn_particles(x)
	spawn_particles(y)
	spawn_particles(z)
	
func spawn_particles(obj:GPUParticles2D):
	obj.global_position = self.global_position
	obj.emitting = false
	obj.scale *= self.scale / normal_scale
	if level:
		level.add_child(obj)

func _process(delta: float) -> void:
	look_at(player.global_position)
	var to_player = player.global_position - global_position
	var dir = to_player.normalized()
	var move_vec = (dir * speed * delta)
	global_position += move_vec
	#self.position += Vector2(0, -speed * delta).rotated(self.rotation + deg_to_rad(90))
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(self.damage)
		die()
	pass # Replace with function body.
