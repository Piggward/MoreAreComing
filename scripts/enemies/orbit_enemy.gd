extends Area2D

var angle = 0.0
var speed = 0.5
var radian = 500.0
var max_radian = 500.0
var start_speed = 0.5
var xmin = 500
var xmax = 0
var target = Vector2.ZERO

var radial_speed = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	radian = -1
	target = get_tree().get_first_node_in_group("player").global_position
	await get_tree().create_timer(2).timeout
	radian = (self.global_position - target).length()
	angle = get_angle_to(target)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if radian < 0:
		return
	angle += speed * get_process_delta_time()
	var x = cos(angle)
	var y = sin(angle)
	
	global_position.x = target.x + (x * radian)
	global_position.y = target.y + (y * radian)
	radian -= 0.4
	speed = clamp(start_speed * ((max_radian / radian) / 4), start_speed, start_speed * 6)
	pass
