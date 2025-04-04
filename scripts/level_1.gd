extends Node2D

@export var waves: Array[Wave]
@onready var enemy_manager: Node2D = $EnemyManager
var current_batch: int
var current_wave: Wave
var current_wave_number = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_manager.batch_spawned.connect(_on_batch_spawned)
	enemy_manager.enemies_cleared.connect(_on_enemies_cleared)
	current_wave = waves[0]
	spawn_wave()
	pass # Replace with function body.
	
func _on_enemies_cleared():
	next_wave()
	
func next_wave():
	print("next wave!")
	current_wave_number += 1 
	if current_wave_number >= waves.size():
		print("CONGRATS U WON!!")
		return
	current_wave = waves[current_wave_number]
	spawn_wave()

func _on_batch_spawned():
	print("batch spawned!")
	await get_tree().create_timer(current_wave.batch_cd).timeout
	if current_batch > 0:
		spawn_batch()

func spawn_wave():
	current_batch = current_wave.batch
	spawn_batch()
	
func spawn_batch():
	current_batch -= 1
	enemy_manager.spawn_batch(current_wave.enemies, current_batch == 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
