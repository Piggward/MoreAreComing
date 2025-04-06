extends Node2D

@export var waves: Array[Wave]
@onready var enemy_manager: Node2D = $EnemyManager
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
@onready var reload_reminder = $CanvasLayer/ReloadReminder
const TANKS_SONG = preload("res://sfx/tanks_song.wav")
const GOODJOB = preload("res://sfx/Goodjob.mp3")
var player: Player
@onready var timer = $Timer
@onready var exp_progress_bar = $CanvasLayer/UI/ProgressBar
var current_batch = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_manager.enemies_cleared.connect(_on_enemies_cleared)
	enemy_manager.enemy_killed.connect(_on_enemy_killed)
	current_wave = waves[0]
	progress_bar.visible = false
	ui.visible = false
	start_game_screen.visible = true
	music.stream = TANKS_SONG
	player = get_tree().get_first_node_in_group("player")
	exp_progress_bar.max_value = player.level_progression[player.current_level]
	exp_progress_bar.value = 0
	wave_label.text = "STAGE LEVEL 1"

	#music["parameters/switch_to_clip"] = "Silence"
	pass # Replace with function body.
	
func start_game():
	progress_bar.visible = true
	ui.visible = true
	start_game_screen.visible = false
	music.play()
	spawn_wave()
	
func _on_enemy_killed():
	if player.current_level + 1 >= player.level_progression.size():
		return
	exp_progress_bar.value = enemy_manager.enemies_killed
	if enemy_manager.enemies_killed >= player.level_progression[player.current_level]:
		player.current_level += 1
		on_level_up()
		
func on_level_up():
	wave_cleared.play()
	enemy_manager.enemies_killed = 0
	timer.set_paused(true)
	for g in get_tree().get_nodes_in_group("pauseable"):
		g.process_mode = Node.PROCESS_MODE_DISABLED
	shop.provide_powerups()
	exp_progress_bar.max_value = player.level_progression[player.current_level]
	exp_progress_bar.value = 0
	
	
func _on_enemies_cleared():
	if current_wave_number >= waves.size() - 1:
		game_over(true)
		return
	wave_cleared.play()
	turret.reset()
	reload_reminder.visible = false
	shop.provide_powerups()
	turret.process_mode = Node.PROCESS_MODE_DISABLED
	
func game_over(won: bool):
	var s = GAME_OVER_SCREEN.instantiate()
	s.won = won
	canvas_layer.add_child(s)
	self.process_mode = Node.PROCESS_MODE_DISABLED
	
func next_wave():
	wave_start.play()
	for g in get_tree().get_nodes_in_group("pauseable"):
		g.process_mode = Node.PROCESS_MODE_INHERIT
	timer.set_paused(false)

func spawn_wave():
	print("spawning batch!")
	spawn_batch()
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
	wave_label.text = "STAGE LEVEL " + str(current_wave_number + 1)
	
func spawn_batch():
	enemy_manager.spawn_batch(current_wave.enemies, current_wave)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_button_button_down():
	#next_wave()
	#shop.leave_shop()
	#control.visible = false
	#pass # Replace with function body.


func _on_button_button_up():
	shop.leave_shop()
	control.visible = false
	next_wave()
	pass # Replace with function body.
