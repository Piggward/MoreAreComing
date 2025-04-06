extends Node2D

const ENEMY = preload("res://scenes/enemy.tscn")
@export var damage: int
@export var speed: float
var positions: Array[Node]
var min_enemy_time = 0.1
var max_enemy_time = 0.3
var alive_enemies = 0
var await_enemies = false
signal batch_spawned
signal enemies_cleared
const SPEEDY_ENEMY = preload("res://scenes/speedy_enemy.tscn")
const TANKY_ENEMY = preload("res://scenes/tanky_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	positions = get_children()
	pass # Replace with function body.

func spawn_batch(batch: int, wave: Wave, last_batch: bool):
	await_enemies = last_batch
	for i in batch:
		var sp = randf_range(0.0, 1.0)
		var ps = 0 if sp > wave.special_factor else 1 if sp > wave.special_factor / 2 else 2
		spawn_enemy(wave, ps)
		await get_tree().create_timer(randf_range(min_enemy_time, max_enemy_time)).timeout
	batch_spawned.emit()
	
func spawn_enemy(wave: Wave, special: int):
	var random = positions[(randi_range(0, positions.size()-1))]
	var random_offset_x = randi_range(-5, 5)
	var random_offset_y = randi_range(-5, 5)
	var e = ENEMY.instantiate() if special == 0 else SPEEDY_ENEMY.instantiate() if special == 1 else TANKY_ENEMY.instantiate()
	random.add_child(e)
	e.position = Vector2(random_offset_x, random_offset_y)
	e.speed = wave.speed
	e.damage = wave.damage
	e.max_health = wave.health
	alive_enemies += 1
	e.died.connect(_on_enemy_died)
	
func _on_enemy_died():
	alive_enemies -= 1
	if alive_enemies == 0 && await_enemies:
		print("all enemies dead")
		enemies_cleared.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
