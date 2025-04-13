extends Node2D

var player: Player
const BASE_MAX_OFFSET := 30       # Min camera offset range
const MAX_EXTRA_OFFSET := 70      # Max *additional* offset (so total max = 30 + 70 = 100)
const MAX_CURSOR_DISTANCE := 800  # How far the mouse can be to reach full offset effect

const MIN_EASING := 0.025
const MAX_EASING := 0.07
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	self.global_position = player.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		# Get global positions
	var player_pos = player.global_position
	var camera_pos = global_position
	var mouse_screen_pos = get_viewport().get_mouse_position()
	var mouse_world_pos = get_global_mouse_position()

	# STEP 1: Determine offset direction from player to mouse
	var direction_to_mouse = mouse_world_pos - player_pos
	var distance_to_mouse_from_player = direction_to_mouse.length()

	# Clamp the offset relative to player position
	var max_offset = BASE_MAX_OFFSET + (MAX_EXTRA_OFFSET * clamp(distance_to_mouse_from_player / MAX_CURSOR_DISTANCE, 0.0, 1.0))
	if direction_to_mouse.length() > max_offset:
		direction_to_mouse = direction_to_mouse.normalized() * max_offset

	var target_pos = player_pos + direction_to_mouse

	# STEP 2: Determine easing speed based on distance between camera and mouse
	var camera_to_mouse_dist = (mouse_world_pos - camera_pos).length()
	var easing_ratio = clamp(camera_to_mouse_dist / MAX_CURSOR_DISTANCE, 0.0, 1.0)
	var easing = lerp(MIN_EASING, MAX_EASING, easing_ratio)
	var lerp_speed = 1.0 - pow(1.0 - easing, delta * 60)

	# Smoothly move the camera towards the clamped target
	global_position = global_position.lerp(target_pos, lerp_speed)
	#var player_pos = player.global_position
	#var mouse_pos = get_viewport().get_mouse_position()
	#var mouse_world_pos = get_global_mouse_position()
	#
	#var raw_direction = mouse_world_pos - player_pos
	#var raw_distance = raw_direction.length()
#
	## Get ratio of how far the cursor is (0.0 to 1.0)
	#var distance_ratio = clamp(raw_distance / MAX_CURSOR_DISTANCE, 0.0, 1.0)
#
	## Compute dynamic max offset
	#var max_offset = BASE_MAX_OFFSET + (MAX_EXTRA_OFFSET * distance_ratio)
#
	## Clamp direction to dynamic max
	#var clamped_direction = raw_direction
	#if raw_distance > max_offset:
		#clamped_direction = raw_direction.normalized() * max_offset
#
	#var target_pos = player_pos + clamped_direction
#
	## Dynamic easing based on distance ratio
	#var easing = lerp(MIN_EASING, MAX_EASING, distance_ratio)
	#var lerp_speed = 1.0 - pow(1.0 - easing, delta * 60)
#
	#global_position = global_position.lerp(target_pos, lerp_speed)
	pass
