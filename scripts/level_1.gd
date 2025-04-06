extends Node2D

@export var waves: Array[Wave]
@onready var enemy_manager: Node2D = $EnemyManager
var current_batch: int
var current_wave: Wave
var current_wave_number = 0
@onready var control = $CanvasLayer/Control
@onready var turret = $Turret
@onready var wave_cleared = $WaveCleared
@onready var wave_start = $WaveStart
@onready var shop = $CanvasLayer/Shop
@onready var wave_label = $CanvasLayer/UI/PanelContainer2/Wave_label
const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")
@onready var canvas_layer = $CanvasLayer
@onready var ui = $CanvasLayer/UI
@onready var progress_bar = $CanvasLayer/ProgressBar
@onready var music = $Music
@onready var start_game_screen = $CanvasLayer/StartGameScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_manager.batch_spawned.connect(_on_batch_spawned)
	enemy_manager.enemies_cleared.connect(_on_enemies_cleared)
	current_wave = waves[0]
	progress_bar.visible = false
	ui.visible = false
	music.stop()
	start_game_screen.visible = true
	#spawn_wave()
	pass # Replace with function body.
	
func start_game():
	progress_bar.visible = true
	ui.visible = true
	start_game_screen.visible = false
	music.play()
	
func _on_enemies_cleared():
	if current_wave_number >= waves.size() - 1:
		game_over(true)
		return
	wave_cleared.play()
	shop.provide_powerups()
	turret.process_mode = Node.PROCESS_MODE_DISABLED
	
func game_over(won: bool):
	var s = GAME_OVER_SCREEN.instantiate()
	s.won = won
	canvas_layer.add_child(s)
	self.process_mode = Node.PROCESS_MODE_DISABLED
	
func next_wave():
	wave_start.play()
	turret.process_mode = Node.PROCESS_MODE_INHERIT
	turret.reset()
	current_wave_number += 1 
	current_wave = waves[current_wave_number]
	wave_label.text = "WAVE " + str(current_wave_number + 1) + " / " + str(waves.size())
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
	enemy_manager.spawn_batch(current_wave.enemies, current_wave, current_batch == 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_button_button_down():
	#next_wave()
	#shop.leave_shop()
	#control.visible = false
	#pass # Replace with function body.


func _on_button_button_up():
	next_wave()
	shop.leave_shop()
	control.visible = false
	pass # Replace with function body.
