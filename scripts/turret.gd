class_name Turret
extends Node2D

const SHOOT_AREA = preload("res://scenes/shoot_area.tscn")
@onready var nozzle: Marker2D = $Nozzle
@onready var rotating_pipe: AudioStreamPlayer = $RotatingPipe
@onready var shoot_audio = $ShootAudio
@onready var progress_bar = $"../CanvasLayer/UI/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/ProgressBar"
@onready var shot_container = $"../ShotContainer"

var player: Player
var shoot_ready: bool = true
var shots_left: int = 10
var original_pitch: float
var original_pitch2: float
var og_pos: Vector2
var reloading: bool = false

signal shot_fired
signal reload_requested
signal ammo_updated(new_ammo: int, mag_size: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	original_pitch = rotating_pipe.pitch_scale
	original_pitch2 = shoot_audio.pitch_scale
	og_pos = position
	pass # Replace with function body.
	
func reload():
	reloading = true
	reload_requested.emit()
	
func reset():
	reloading = false
	player.basic_power.shots_left = player.basic_power.mag_size
	ammo_updated.emit(player.basic_power.shots_left, player.basic_power.mag_size)

func shoot(power: Power):
	spawn_power(power)
	shoot_effects()
	if power is BasicPower:
		update_ammo()
	
func shoot_effects():
	shoot_audio.pitch_scale = original_pitch2 + randf_range(0, 0.04)
	nozzle.light()
	shoot_audio.play()
	self.position = og_pos + Vector2(0, 20).rotated(self.rotation + deg_to_rad(90))
	
func update_ammo():
	ammo_updated.emit(player.basic_power.shots_left, player.basic_power.mag_size)
	shot_fired.emit()
	
func spawn_power(p: Power):
	var scenes: Array[ShootArea] = p.get_shot_instances()
	for i in scenes.size():
		var power = scenes[i].power
		scenes[i].direction = power.get_direction(self)
		scenes[i].player_color = player.primary_color
		scenes[i].global_position = self.global_position + power.get_position(nozzle).rotated(self.rotation)
		shot_container.add_child(scenes[i])
	shoot_effects()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ro = get_angle_to(get_global_mouse_position())
	var factor = -1 if ro < 0 else 1
	if abs(ro) > (player.stats.turn_rate * delta * 2):
		if not rotating_pipe.playing:
			var rpitch = 0.01 * factor
			rotating_pipe.pitch_scale += rpitch
			rotating_pipe.play()
	else:
		rotating_pipe.stop()
		rotating_pipe.pitch_scale = original_pitch
	#var add_ro = get_angle_to(get_global_mouse_position()) if ro < 0.005 else get_angle_to(get_global_mouse_position()) * player.stats.turn_rate
	if abs(ro) < 0.05:
		self.rotation += ro
	else:
		self.rotation += (player.stats.turn_rate * delta) * factor
		
	position = lerp(position, og_pos, 0.1)
	pass
