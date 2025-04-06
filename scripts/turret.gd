class_name Turret
extends Node2D

@onready var nozzle: Marker2D = $Nozzle
var player: Player
var shoot_ready: bool = true
var shots_left: int
signal shot_fired
signal reload_requested
const SHOOT_AREA = preload("res://scenes/shoot_area.tscn")
var original_pitch: float
var original_pitch2: float
@onready var audio_stream_player = $AudioStreamPlayer
@onready var shoot_audio = $ShootAudio
@onready var progress_bar = $"../CanvasLayer/UI/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/ProgressBar"
var og_pos: Vector2
@onready var reload_reminder = $"../CanvasLayer/ReloadReminder"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	shots_left = player.mag_size
	original_pitch = audio_stream_player.pitch_scale
	original_pitch2 = shoot_audio.pitch_scale
	og_pos = position
	pass # Replace with function body.
	
func reload():
	reload_requested.emit()
	
func reset():
	shots_left = player.mag_size
	shot_fired.emit()

func shoot():
	if not shoot_ready or shots_left == 0 or progress_bar.reloading:
		return
	shoot_ready = false
	var s = SHOOT_AREA.instantiate()
	s.direction = self.rotation - deg_to_rad(90)
	s.speed = player.shoot_speed
	s.global_position = nozzle.global_position
	s.damage = player.damage
	s.pierce = player.pierce
	s.knock_back = player.knock_back
	get_parent().add_child(s)
	shots_left -= 1
	if shots_left == 0:
		reload_reminder.visible = true
	shot_fired.emit()
	shoot_audio.pitch_scale = original_pitch2 + randf_range(0, 0.04)
	nozzle.light()
	shoot_audio.play()
	self.position += Vector2(0, 20).rotated(self.rotation + deg_to_rad(90))
	if player.has_automatic_reload and shots_left == 0:
		reload_requested.emit()
	await get_tree().create_timer(player.shoot_cd).timeout
	shoot_ready = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ro = get_angle_to(get_global_mouse_position())
	var factor = -1 if ro < 0 else 1
	if abs(ro) > player.turn_rate * 4:
		if not audio_stream_player.playing:
			var rpitch = 0.01 * factor
			audio_stream_player.pitch_scale += rpitch
			audio_stream_player.play()
	else:
		audio_stream_player.stop()
		audio_stream_player.pitch_scale = original_pitch
	#var add_ro = get_angle_to(get_global_mouse_position()) if ro < 0.005 else get_angle_to(get_global_mouse_position()) * player.turn_rate
	if abs(ro) < player.turn_rate:
		self.rotation += ro
	else:
		self.rotation += player.turn_rate * factor
		
	position = lerp(position, og_pos, 0.1)
	pass
