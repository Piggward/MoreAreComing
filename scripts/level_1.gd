class_name Level
extends Node2D

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")

@export var waves: Array[Wave]
@onready var wave_cleared = $WaveCleared
@onready var wave_start = $WaveStart
@onready var wave_label = $CanvasLayer/UI/PanelContainer2/Wave_label
@onready var canvas_layer = $CanvasLayer
@onready var music = $Music

var wave_timer: Timer
var shop: Shop
var player: Player
var current_wave: Wave
var current_wave_number = 0
var current_batch = 0
signal new_wave(wave: Wave)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	load_waves("res://data/waves.json")
	print("Loaded waves: ", waves.size())
	current_wave = waves[current_wave_number]
	wave_timer.start(current_wave.wave_duration)
	
func _next_wave():
	current_wave_number += 1
	current_wave = waves[current_wave_number]
	new_wave.emit(current_wave)
	wave_timer.start(current_wave.wave_duration)

func _on_player_health_updated(health: int, max_health: int):
	if health <= 0:
		game_over(false)
	
func start_game():
	#music.play()
	pass
	
func resume_game():
	get_tree().paused = false
	wave_timer.set_paused(false)
		
func on_level_up(new_level):
	wave_cleared.play()
	wave_timer.set_paused(true)
	get_tree().paused = true
	
func game_over(won: bool):
	var s = GAME_OVER_SCREEN.instantiate()
	s.won = won
	canvas_layer.add_child(s)
	get_tree().paused = true
	
func load_waves(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not open %s: %s" % [path, error_string(FileAccess.get_open_error())])
		return

	var data = JSON.parse_string(file.get_as_text())
	if !(data is Array):
		push_error("Invalid JSON format (expected array).")
		return

	waves.clear()

	for item in data:
		if !(item is Dictionary):
			push_warning("Skipping non-dictionary entry in JSON.")
			continue

		var wave := Wave.new()

		# Build a set of script variable names for this instance.
		var prop_names := {}
		for p in wave.get_property_list():
			# Only include script variables (includes @export vars)
			if (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0:
				prop_names[p.name] = true

		# Assign only known properties
		for key in item.keys():
			if prop_names.has(key):
				wave.set(key, item[key])
			else:
				push_warning("Unknown Wave field '%s' (ignored)." % key)

		waves.append(wave)
