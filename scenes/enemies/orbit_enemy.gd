class_name OrbitEnemy
extends Enemy

var current_target:= Vector2.ZERO
var radius = 50   # Starting radius R
var turns = 5

@export var turn_speed = 2
var turning: bool = false

func _ready():
	super()
	radius = (self.global_position - player.global_position).length() / turns
	set_new_target()
	pass

func _process(delta):
	if turning: 
		var target_rotation = self.global_position.angle_to_point(current_target)
		var r = shortest_angle_diff(self.rotation, target_rotation)
		rotation += clamp(r, -(turn_speed * delta), (turn_speed * delta))
		if abs(r) <= 0.0001:
			await get_tree().create_timer(0.15).timeout
			turning = false
		return
		
	if (self.global_position - current_target).length() < 1 and turns > 0:
		turns -= 1
		set_new_target()
	else:
		look_at(current_target)
		self.position += Vector2(0, -speed * delta).rotated(self.rotation + deg_to_rad(90))
		#global_position = global_position.move_toward(current_target, speed)
		
func set_new_target():
	var angle = self.global_position.angle_to_point(player.global_position) + deg_to_rad(180)
	current_target = player.global_position + Vector2(0, (radius * turns)).rotated(angle)
	turning = true

func shortest_angle_diff(from: float, to: float) -> float:
	var diff = fposmod(to - from + PI, TAU) - PI
	return diff
