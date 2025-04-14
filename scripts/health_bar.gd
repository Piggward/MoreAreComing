extends ProgressBar

var player: Player
@onready var health_label: Label = $HealthLabel

func _ready():
	player = get_tree().get_first_node_in_group("player")
	self.max_value = player.health
	update_health(player.health, player.health)
	
func update_health(health: int, max_health: int):
	self.value = health
	health_label.text = str(health) + " / " + str(max_health)
