extends Sprite2D

@export var colors: Array[Color]
var primary_color: Color

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if not player.is_node_ready():
		await player.ready
	change_color(self.material.get_shader_parameter("primary_color"))
	EventManager.change_color_requested.connect(change_color)
	EventManager.next_color_requested.connect(next_color)
	
func change_color(color):
	self.material.set("shader_param/new_primary_color", color) 
	self.material.set("shader_param/tolerance", 0.15)
	primary_color = color
	EventManager.primary_color_change.emit(primary_color)
	
func next_color():
	var color = colors.pop_front()
	colors.push_back(color)
	change_color(color)
