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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	positions = get_children()
	pass # Replace with function body.

func spawn_batch(batch: int, last_batch: bool):
	await_enemies = last_batch
	for i in batch:
		spawn_enemy()
		await get_tree().create_timer(randf_range(min_enemy_time, max_enemy_time)).timeout
	batch_spawned.emit()
	
func spawn_enemy():
	var random = positions[(randi_range(0, positions.size()-1))]
	var random_offset_x = randi_range(-5, 5)
	var random_offset_y = randi_range(-5, 5)
	var e = ENEMY.instantiate()
	random.add_child(e)
	e.position = Vector2(random_offset_x, random_offset_y)
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
