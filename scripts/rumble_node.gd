class_name RumbleNode
extends Node2D

# Parameters to control the rumble effect
@export var rumble_duration: float = 0.5      # How long the rumble should go on
@export var max_intensity: float = 4       # Max shake intensity
@export var ramp_speed: float = 1   
@export var destination: Vector2

var _elapsed_time := 0.0
var _original_position := Vector2.ZERO
var _is_rumbling := false
var pickup = false
var exp_bar: ExperienceBar
var has_landed = false

func _ready():
	_original_position = destination
	exp_bar = get_tree().get_first_node_in_group("experience_bar")

func start_rumble():
	_elapsed_time = 0.0
	_is_rumbling = true
	
func stop_rumble():
	_is_rumbling = false
	position = _original_position

func _process(delta):
	if _is_rumbling:
		_elapsed_time += delta

		var progress = clamp(_elapsed_time / rumble_duration, 0.0, 1.0)
		var intensity = lerp(0.0, max_intensity, pow(progress, ramp_speed))

		# Apply shaking offset
		position = _original_position + Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)

		if _elapsed_time >= rumble_duration:
			stop_rumble()
			pickup = true
			EventManager.exp_pickup.emit()
			
	elif pickup:
		var c_local_to_n_global = get_canvas_transform().affine_inverse() * exp_bar.get_global_transform_with_canvas()
		var n_target_global_position: Vector2 = c_local_to_n_global * (exp_bar.size / 2)
		if (global_position - n_target_global_position).length() < 30: 
			self.queue_free()
		global_position = lerp(global_position, n_target_global_position, 0.04)
		
	elif not has_landed:
		position = lerp(position, destination, 1.0 - pow(0.00005, delta))
		if (position - destination).length() < 1:
			position = destination
			has_landed = true

func _on_area_2d_mouse_entered():
	if not _is_rumbling and not pickup and has_landed and not get_tree().paused:
		start_rumble()
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	if _is_rumbling and not pickup and has_landed:
		stop_rumble()
	pass # Replace with function body.
