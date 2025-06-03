class_name RumbleNode
extends Node2D

# Parameters to control the rumble effect
@export var rumble_duration: float = 0.1      # How long the rumble should go on
@export var max_intensity: float = 4       # Max shake intensity
@export var ramp_speed: float = 1   
@export var exp_worth: int
const EXP_PARTICLE_AREA = preload("res://scenes/exp_particle_area.tscn")

var _elapsed_time := 0.0
var _original_position := Vector2.ZERO
var _is_rumbling := false
var pickup = false
var exp_bar: ExperienceBar

func _ready():
	_original_position = position
	#exp_bar = get_tree().get_first_node_in_group("experience_bar")

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
			for x in exp_worth:
				var i = EXP_PARTICLE_AREA
				var c_local_to_n_global = get_canvas_transform().affine_inverse() * exp_bar.get_global_transform_with_canvas()
				var n_target_global_position: Vector2 = c_local_to_n_global * (exp_bar.size / 2)
				i.target_position = n_target_global_position
				i.pitch = 1 + x * 0.1
				add_child(i)
			#pickup = true
			EventManager.exp_pickup.emit(exp_worth)
			
	elif pickup:
		var c_local_to_n_global = get_canvas_transform().affine_inverse() * exp_bar.get_global_transform_with_canvas()
		var n_target_global_position: Vector2 = c_local_to_n_global * (exp_bar.size / 2)
		if (global_position - n_target_global_position).length() < 30: 
			self.queue_free()
		global_position = lerp(global_position, n_target_global_position, 0.04)

func _on_area_2d_mouse_entered():
	if not _is_rumbling and not pickup and not get_tree().paused:
		start_rumble()
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	if _is_rumbling and not pickup:
		stop_rumble()
	pass # Replace with function body.
