extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = get_tree().get_first_node_in_group("player").primary_color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
