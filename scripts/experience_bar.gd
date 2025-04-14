class_name ExperienceBar
extends ProgressBar

var player: Player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	self.max_value = player.level_progression[player.current_level]
	self.value = 0
	EventManager.experience_updated.connect(update_values)
	EventManager.experience_added.connect(update_value)
	pass # Replace with function body.

func update_values(v: int, max_v: int):
	value = v
	max_value = max_v
	
func update_value(v: int):
	value = v
	
