class_name Turret
extends Node2D

const SHOOT_AREA = preload("res://scenes/shoot_area.tscn")
const PIPE_PITCH = 0.7
const SHOOT_PITCH = 1.0
const RELOAD_2 = preload("res://sfx/reload1.mp3")
const RELOAD_1 = preload("res://sfx/reload2.mp3")

@onready var nozzle: Marker2D = $Nozzle
@onready var rotating_pipe: AudioStreamPlayer = $RotatingPipe
@onready var shoot_audio = $ShootAudio
@onready var reload_audio = $ReloadAudio
@onready var nozzle_2 = $Nozzle2

var player: Player
var shoot_ready: bool = true
var shots_left: int = 10
var og_pos: Vector2
var reloading: bool = false
var current_reload_time: float = 0.0
var s1_played = false
var s2_played = false
var nozzles = []


signal shot_fired
signal reload_started
signal reload_finished
signal ammo_updated(new_ammo: int, mag_size: int)
signal power_spawn(shot: ShootArea)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	og_pos = position
	reload_audio.stream = RELOAD_1
	nozzles.append(nozzle)
	nozzles.append(nozzle_2)
	pass # Replace with function body.
	
func reload():
	if reloading:
		return
	s1_played = false
	s2_played = false
	reloading = true
	reload_started.emit()
	
func reset():
	reloading = false
	player.basic_power.shots_left = player.basic_power.mag_size
	ammo_updated.emit(player.basic_power.shots_left, player.basic_power.mag_size)
	reload_finished.emit()

func shoot(power: Power):
	spawn_power(power)
	if power is BasicPower:
		shoot_effects()
		update_ammo()
		if power.shots_left == 0 and power.automatic_reload: 
			reload()
	
func shoot_effects():
	shoot_audio.pitch_scale = SHOOT_PITCH + randf_range(0, 0.04)
	nozzles[1].light()
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
		scenes[i].global_position = self.global_position + power.get_position(get_nozzle()).rotated(self.rotation)
		power_spawn.emit(scenes[i])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if reloading: 
		handle_reload(delta)
	var ro = get_angle_to(get_global_mouse_position())
	var factor = -1 if ro < 0 else 1
	if abs(ro) > (player.stats.turn_rate * delta * 2):
		if not rotating_pipe.playing:
			var rpitch = 0.01 * factor
			rotating_pipe.pitch_scale += rpitch
			rotating_pipe.play()
	else:
		rotating_pipe.stop()
		rotating_pipe.pitch_scale = PIPE_PITCH
	#var add_ro = get_angle_to(get_global_mouse_position()) if ro < 0.005 else get_angle_to(get_global_mouse_position()) * player.stats.turn_rate
	if abs(ro) < 0.05:
		self.rotation += ro
	else:
		self.rotation += (player.stats.turn_rate * delta) * factor
		
	position = lerp(position, og_pos, 0.1)
	pass
	
func get_nozzle():
	var n = nozzles.pop_front()
	nozzles.append(n)
	return n

func handle_reload(delta):
	current_reload_time += delta
	var v = current_reload_time / player.stats.reload_speed
	if not s1_played and v > 0.2:
		reload_audio.stream = RELOAD_1
		reload_audio.play()
		s1_played = true
	if not s2_played and v > 0.9:
		reload_audio.stream = RELOAD_2
		reload_audio.play()
		s2_played = true
	if v >= 1:
		reset()
		current_reload_time = 0.0
	pass
