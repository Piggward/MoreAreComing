extends Control

var camera: Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_tree().get_first_node_in_group("camera")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	if get_tree().get_first_node_in_group("turret").shots_left > 0:
		camera.play_intro()
	pass # Replace with function body.
