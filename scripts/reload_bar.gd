extends ProgressBar

const RELOAD_2 = preload("res://sfx/reload1.mp3")
const RELOAD_1 = preload("res://sfx/reload2.mp3")

@onready var reload_audio: AudioStreamPlayer = $"../ReloadAudio"

var player: Player
var turret: Turret
var show_reload_progress = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	turret = get_tree().get_first_node_in_group("turret")
	turret.reload_started.connect(_on_reload_started)
	turret.reload_finished.connect(_on_reload_finished)
	pass # Replace with function body.
	
func _on_reload_started():
	show_reload_progress = true
	self.visible = true
	
func _on_reload_finished():
	show_reload_progress = false
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if show_reload_progress:
		var v = turret.current_reload_time / player.stats.reload_speed
		self.value = clamp(v * 100, 0, 100)
	pass
