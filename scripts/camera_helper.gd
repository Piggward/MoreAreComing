extends Node2D

@export var max_x: float
@export var max_y: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x = get_viewport().get_mouse_position()
	var y = Vector2(get_viewport().size / 2)
	var mouse_offset = ( x - y )
	position = lerp(Vector2(), mouse_offset.normalized() * 10, mouse_offset.length() / 100)
	position.x = clamp(position.x, -max_x, max_x ) 
	position.y = clamp(position.y, -max_y, max_y)
	pass
