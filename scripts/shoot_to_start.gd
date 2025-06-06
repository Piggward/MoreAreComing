extends Area2D

const EXPLOSION_PARTICLES = preload("res://scenes/explosion_particles.tscn")

@export var type: TYPE

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var label = $PanelContainer/MarginContainer/Label

enum TYPE { START_GAME, CHANGE_COLOR, RANDOM_COLOR }
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		self.TYPE.START_GAME:
			label.text = "Start game"
		self.TYPE.CHANGE_COLOR:
			label.text = "Change color"
		self.TYPE.RANDOM_COLOR:
			label.text = "Random color"
	
	player = get_tree().get_first_node_in_group("player")
	EventManager.start_game.connect(func(): self.queue_free())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game_area_enter(area):
	for child in get_children():
		if child is not AudioStreamPlayer2D:
			child.visible = false
	area.queue_free()
	var particles = EXPLOSION_PARTICLES.instantiate()
	particles.emitting = true
	particles.scale *= 2
	particles.global_position = global_position
	audio_stream_player_2d.global_position = global_position
	var camera = get_tree().get_first_node_in_group("camera")
	camera.add_trauma(100)
	get_parent().add_child(particles)
	audio_stream_player_2d.play()
	audio_stream_player_2d.reparent(get_parent())
	EventManager.start_game.emit()

func change_color_area_enter(area):
	area.queue_free()
	EventManager.next_color_requested.emit()
	
func random_color_area_enter(area):
	area.queue_free()
	var rand_color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	EventManager.change_color_requested.emit(rand_color)

func _on_area_entered(area):
	match type:
		self.TYPE.START_GAME:
			start_game_area_enter(area)
		self.TYPE.CHANGE_COLOR:
			change_color_area_enter(area)
		self.TYPE.RANDOM_COLOR:
			random_color_area_enter(area)
	pass # Replace with function body.
