class_name EnemyManager
extends Node2D

const ENEMY = preload("res://scenes/enemy.tscn")
const SPEEDY_ENEMY = preload("res://scenes/speedy_enemy.tscn")
const TANKY_ENEMY = preload("res://scenes/tanky_enemy.tscn")
@onready var level_1 = $".."

@export var damage: int
@export var speed: float

var positions: Array[Node]
var min_enemy_time = 0.1
var enemies_killed = 0
var total_enemies_killed = 0

signal batch_spawned
signal enemy_killed(enemy: Enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	positions = get_children()
	level_1.spawn_batch_requested.connect(spawn_batch)
	pass # Replace with function body.

func spawn_batch(batch: int, wave: Wave):
	positions.shuffle()
	for i in batch:
		var sp = randf_range(0.0, 1.0)
		var ps = 0 if sp > wave.special_factor else 1 if sp > wave.special_factor / 2 else 2
		spawn_enemy(wave, ps)
		await get_tree().create_timer(0.1).timeout
	batch_spawned.emit()
	
func spawn_enemy(wave: Wave, special: int):
	var random = positions.pop_front()
	var random_offset_x = randi_range(-5, 5)
	var random_offset_y = randi_range(-5, 5)
	var e = ENEMY.instantiate() if special == 0 else SPEEDY_ENEMY.instantiate() if special == 1 else TANKY_ENEMY.instantiate()
	e.position = Vector2(random_offset_x, random_offset_y)
	e.speed = wave.speed
	e.damage = wave.damage
	e.max_health = wave.health
	e.died.connect(_on_enemy_died)
	random.add_child(e)
	positions.push_back(random)
	
func _on_enemy_died(enemy: Enemy):
	enemies_killed += 1
	enemy_killed.emit(enemy)
