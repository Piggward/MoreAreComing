extends Marker2D
@onready var shoot_light = $Shoot_light
var cd = false
const TIME = 0.07
var ctime = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func light():
	if cd:
		return
	shoot_light.visible = true
	cd = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cd: 
		ctime += delta
		if ctime > TIME: 
			shoot_light.visible = false
			cd = false
			ctime = 0
	pass
