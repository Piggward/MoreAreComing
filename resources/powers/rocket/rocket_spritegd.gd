extends Sprite2D


func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if not player.is_node_ready():
		await player.ready
	change_color(self.material.get_shader_parameter("primary_color"))
	EventManager.change_color_requested.connect(change_color)
	change_color(player.primary_color)
	
func change_color(color):
	self.material.set("shader_param/new_primary_color", color) 
	self.material.set("shader_param/tolerance", 0.3)
