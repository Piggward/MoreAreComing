extends Label

var player: Player
var turret: Turret
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	turret = get_tree().get_first_node_in_group("turret")
	turret.shot_fired.connect(_on_shot_fired)
	player.attributes_updated.connect(_on_shot_fired)
	_on_shot_fired()
	pass # Replace with function body.

func _on_shot_fired():
	self.text = str(turret.shots_left) + " / " + str(player.mag_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
