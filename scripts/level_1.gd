class_name Level
extends Node2D

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")
const TANKS_SONG = preload("res://sfx/tanks_song.wav")
const GOODJOB = preload("res://sfx/Goodjob.mp3")
const ENEMY_EXP_FACTOR = 5

@export var waves: Array[Wave]

@onready var enemy_manager: Node2D = $EnemyManager
@onready var control = $CanvasLayer/Control
@onready var wave_cleared = $WaveCleared
@onready var wave_start = $WaveStart
@onready var shop = $CanvasLayer/Shop
@onready var wave_label = $CanvasLayer/UI/PanelContainer2/Wave_label
@onready var canvas_layer = $CanvasLayer
@onready var music = $Music
@onready var timer = $Timer
@onready var exp_progress_bar = $CanvasLayer/UI/ProgressBar
@onready var exp_manager = $ExpManager

var player: Player
var current_wave: Wave
var current_wave_number = 0
var current_batch = 0
var current_enemies_killed = 0

signal spawn_batch_requested(amount: int, wave: Wave)

func should_drop_exp():
	var rand = randf_range(0.0, 1.0)
	var should_drop = float(current_enemies_killed) / float(ENEMY_EXP_FACTOR) > rand
	if should_drop:
		current_enemies_killed = 0
	return should_drop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.exp_pickup.connect(_on_exp_pickup)
	current_wave = waves[0]
	player = get_tree().get_first_node_in_group("player")
	player.health_updated.connect(_on_player_health_updated)
	EventManager.start_game.connect(start_game)
	self.process_mode = Node.PROCESS_MODE_INHERIT
	enemy_manager.enemy_killed.connect(_on_enemy_killed)
	get_tree().paused = false

func _on_player_health_updated(health: int, max_health: int):
	if health <= 0:
		game_over(false)
	
func _on_enemy_killed(enemy: Enemy):
	current_enemies_killed += 1
	if enemy.drops_exp:
		exp_manager._spawn_exp(enemy.global_position, current_enemies_killed)
		current_enemies_killed = 0
	
func start_game():
	music.play()
	spawn_wave()
	
func _on_exp_pickup(value: int):
	player.exp += value
	EventManager.experience_added.emit(player.exp)
	if player.current_level + 1 >= player.level_progression.size():
		return
	exp_progress_bar.value = player.exp
	if player.exp >= player.level_progression[player.current_level]:
		player.current_level += 1
		on_level_up()
		
func on_level_up():
	wave_cleared.play()
	player.exp = 0
	enemy_manager.enemies_killed = 0
	timer.set_paused(true)
	get_tree().paused = true
	shop.provide_powerups()
	
	EventManager.experience_updated.emit(0, player.level_progression[player.current_level])
	
func game_over(won: bool):
	var s = GAME_OVER_SCREEN.instantiate()
	s.won = won
	canvas_layer.add_child(s)
	get_tree().paused = true
	
func next_wave():
	get_tree().paused = false
	timer.set_paused(false)

func spawn_wave():
	spawn_batch_requested.emit(current_wave.enemies, current_wave)
	timer.start(current_wave.batch_cd)
	current_batch += 1
	if current_batch > current_wave.batches:
		increase_wave()
	await timer.timeout
	spawn_wave()
	
func increase_wave():
	current_wave_number += 1
	if current_wave_number >= waves.size():
		game_over(true)
		return
	current_wave = waves[current_wave_number]
	current_batch = 0
	EventManager.next_wave.emit(current_wave_number + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up():
	EventManager.exit_shop.emit()
	next_wave()
	pass # Replace with function body.
