class_name Level
extends Node2D

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")
const TANKS_SONG = preload("res://sfx/tanks_song.wav")
const GOODJOB = preload("res://sfx/Goodjob.mp3")
const ENEMY_EXP_FACTOR = 5
const ENEMY = preload("res://scenes/enemy.tscn")
const TIME_BETWEEN_WAVES = 60

@export var waves: Array[Wave]
@onready var enemy_manager: Node2D = $EnemyManager
@onready var control = $CanvasLayer/Control
@onready var wave_cleared = $WaveCleared
@onready var wave_start = $WaveStart
@onready var wave_label = $CanvasLayer/UI/PanelContainer2/Wave_label
@onready var canvas_layer = $CanvasLayer
@onready var music = $Music
@onready var timer = $Timer
@onready var exp_progress_bar = $CanvasLayer/UI/ProgressBar
@onready var exp_manager = $ExpManager

var wave_timer: Timer
var shop: Shop
var player: Player
var current_wave: Wave
var current_wave_number = 0
var current_batch = 0

signal new_wave(wave: Wave)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_wave = waves[current_wave_number]
	player = get_tree().get_first_node_in_group("player")
	shop = get_tree().get_first_node_in_group("shop")
	shop.exit_shop.connect(resume_game)
	player.health_updated.connect(_on_player_health_updated)
	player.level_up.connect(on_level_up)
	EventManager.start_game.connect(start_game)
	self.process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().paused = false
	wave_timer = Timer.new()
	wave_timer.timeout.connect(_next_wave)
	add_child(wave_timer)
	wave_timer.start(TIME_BETWEEN_WAVES)
	
func _next_wave():
	current_wave_number += 1
	current_wave = waves[current_wave_number]
	new_wave.emit(current_wave)
	wave_timer.start(TIME_BETWEEN_WAVES)

func _on_player_health_updated(health: int, max_health: int):
	if health <= 0:
		game_over(false)
	
func start_game():
	music.play()
	
func resume_game():
	get_tree().paused = false
	timer.set_paused(false)
		
func on_level_up(new_level):
	wave_cleared.play()
	timer.set_paused(true)
	get_tree().paused = true
	
func game_over(won: bool):
	var s = GAME_OVER_SCREEN.instantiate()
	s.won = won
	canvas_layer.add_child(s)
	get_tree().paused = true
