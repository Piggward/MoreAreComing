extends Sprite2D

var clockwise: bool = true
const SPEED = 0.35
const MAX_ROTATION = 22

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clockwise: 
		rotation += delta * SPEED
	else:
		rotation -= delta * SPEED 
	
	if rad_to_deg(abs(rotation)) > MAX_ROTATION:
		clockwise = !clockwise
	pass
