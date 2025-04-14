extends ProgressBar

const RELOAD_2 = preload("res://sfx/reload1.mp3")
const RELOAD_1 = preload("res://sfx/reload2.mp3")

@onready var reload_audio: AudioStreamPlayer = $"../ReloadAudio"

var player: Player
var turret: Turret
var current_wait_time: float
var s1_played = false
var s2_played = false
var show_reload_progress = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	turret = get_tree().get_first_node_in_group("turret")
	turret.reload_requested.connect(_on_reload)
	pass # Replace with function body.
	
func _on_reload():
	if not show_reload_progress:
		current_wait_time = 0
		show_reload_progress = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if show_reload_progress:
		self.visible = true
		current_wait_time += delta
		var v = current_wait_time / player.stats.reload_speed
		self.value = v * 100
		if not s1_played and v > 0.2:
			reload_audio.stream = RELOAD_1
			reload_audio.play()
			s1_played = true
		if not s2_played and v > 0.9:
			reload_audio.stream = RELOAD_2
			reload_audio.play()
			s2_played = true
		if self.value >= max_value:
			turret.reset()
			show_reload_progress = false
			s1_played = false
			s2_played = false
	else:
		self.visible=false
	pass
