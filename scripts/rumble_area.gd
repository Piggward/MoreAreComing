class_name RumbleArea
extends Area2D

# Parameters to control the rumble effect
@export var rumble_duration: float = 1   # How long the rumble should go on
@export var max_intensity: float = 4       # Max shake intensity
@export var ramp_speed: float = 1   
@export var exp_worth: float = 1.0
@export var min_split_amount: int = 5
@export var max_split_amount: int = 25
const EXP_PARTICLE_AREA = preload("res://scenes/exp_particle_area.tscn")
@onready var gpu_particles_2d = $GPUParticles2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
const EXP_BALL_BREAK = preload("res://sfx/exp_ball_break.wav")
const EXP_BALL_RUMBLE = preload("res://sfx/exp_ball_rumble.mp3")

var _elapsed_time := 0.0
var _original_position := Vector2.ZERO
var _is_rumbling := false
var split_amount: int 

func _ready():
	_original_position = position
	split_amount = randi_range(min_split_amount, max_split_amount)

func start_rumble():
	audio_stream_player_2d.stream = EXP_BALL_RUMBLE
	audio_stream_player_2d.play()
	_elapsed_time = 0.0
	_is_rumbling = true
	
func stop_rumble():
	audio_stream_player_2d.stop()
	_is_rumbling = false
	position = _original_position

func _process(delta):
	if _is_rumbling:
		_elapsed_time += delta

		var progress = clamp(_elapsed_time / rumble_duration, 0.0, 1.0)
		var intensity = lerp(0.0, max_intensity, pow(progress, ramp_speed))

		# Apply shaking offset
		position = _original_position + Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)

		if _elapsed_time >= rumble_duration:
			stop_rumble()
			for x in split_amount:
				var i = EXP_PARTICLE_AREA.instantiate()
				i.exp_worth = exp_worth / split_amount
				get_parent().add_child(i)
				i.global_position = self.global_position
			self.visible = false
			audio_stream_player_2d.stream = EXP_BALL_BREAK
			audio_stream_player_2d.play()
			await audio_stream_player_2d.finished
			self.queue_free()
				
		
func _on_mouse_entered():
	if not _is_rumbling and not get_tree().paused:
		start_rumble()
	pass # Replace with function body.


func _on_mouse_exited():
	if _is_rumbling:
		stop_rumble()
	pass # Replace with function body.
