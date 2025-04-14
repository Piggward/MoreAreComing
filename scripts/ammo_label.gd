extends Label

var player: Player
var turret: Turret
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	turret = get_tree().get_first_node_in_group("turret")
	turret.ammo_updated.connect(update_text)
	player.attributes_updated.connect(update_text)
	update_text(turret.shots_left, player.stats.mag_size)
	pass # Replace with function body.

func update_text(shots, mag):
	self.text = str(shots) + " / " + str(mag)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
