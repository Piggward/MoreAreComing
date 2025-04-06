extends ProgressBar

var player: Player
var turret: Turret
var current_wait_time: float
var reloading = false
var s1_played = false
var s2_played = false
@onready var audio_stream_player = $"../AudioStreamPlayer"
const RELOAD_2 = preload("res://sfx/reload1.mp3")
const RELOAD_1 = preload("res://sfx/reload2.mp3")
@onready var reload_reminder = $"../../../../../../../ReloadReminder"

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	turret = get_tree().get_first_node_in_group("turret")
	turret.reload_requested.connect(_on_reload)
	pass # Replace with function body.
	
func _on_reload():
	if not reloading:
		current_wait_time = 0
		reloading = true
		reload_reminder.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reloading:
		self.visible = true
		current_wait_time += delta
		var v = current_wait_time / player.reload_speed
		self.value = v * 100
		if not s1_played and v > 0.2:
			audio_stream_player.stream = RELOAD_1
			audio_stream_player.play()
			s1_played = true
		if not s2_played and v > 0.9:
			audio_stream_player.stream = RELOAD_2
			audio_stream_player.play()
			s2_played = true
		if self.value >= max_value:
			turret.reset()
			reloading = false
			s1_played = false
			s2_played = false
	else:
		self.visible=false
	pass
