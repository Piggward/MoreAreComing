extends Area2D

@export var min_explosion_speed = 500 / 2
@export var max_explosion_speed = 800 / 2
@export var deceleration = 800
@export var acceleration = 1100 
@export var max_homing_speed = 900
#@export var target_position = Vector2.ZERO
@export var homing_delay = 1.0  # Delay before homing starts
@export var exp_worth: float
@export var pitch: float = 1.0

var velocity = Vector2.ZERO
var state = "exploding"
var homing_timer = 0.0
var exp_bar: ExperienceBar
var target: Vector2 
var target_global_pos: Vector2
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

signal reached(exp_worth: float)

func _ready():
	explode_outward()
	exp_bar = get_tree().get_first_node_in_group("experience_bar")
	audio_stream_player_2d.pitch_scale = pitch

func explode_outward():
	var angle = randf() * TAU
	var speed = randf_range(min_explosion_speed, max_explosion_speed)
	velocity = Vector2(cos(angle), sin(angle)) * speed
	rotation = velocity.angle()
	scale = Vector2(1.5, 1.5)  # POP effect
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _physics_process(delta):
	match state:
		"exploding":
			position += velocity * delta
			velocity = velocity.move_toward(Vector2.ONE, deceleration * delta)
			if velocity.length() < 30:
				#velocity = Vector2.ZERO
				state = "charging"
				homing_timer = homing_delay
				var tween = create_tween()
				var c_local_to_n_global = get_canvas_transform().affine_inverse() * exp_bar.get_global_transform_with_canvas()
				target_global_pos = c_local_to_n_global * (exp_bar.size / 2)
				target = (target_global_pos - global_position).normalized()
				tween.tween_property(self, "scale", Vector2(0.8, 1.2), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(self, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		"charging":
			velocity = velocity.move_toward(target * max_homing_speed, acceleration * delta)
			var angle_diff = shortest_angle_diff(rotation, velocity.angle())
			rotation += clamp(angle_diff, -10 * delta, 10 * delta)
			position += velocity * delta
			if abs(angle_diff) <= 0.001:
				state = "homing"

		"homing":
			var c_local_to_n_global = get_canvas_transform().affine_inverse() * exp_bar.get_global_transform_with_canvas()
			target_global_pos = c_local_to_n_global * (exp_bar.size / 2)
			target = (target_global_pos - global_position).normalized()
			velocity = velocity.move_toward(target * max_homing_speed, acceleration * delta)
			position += velocity * delta
			if global_position.y >= target_global_pos.y:
				state = "finished"
				EventManager.exp_pickup.emit(self.exp_worth)
				self.visible = false
				audio_stream_player_2d.play()
				await audio_stream_player_2d.finished
				self.queue_free()
		"finished":
			pass
				
				
func shortest_angle_diff(from: float, to: float) -> float:
	var diff = fposmod(to - from + PI, TAU) - PI
	return diff
	
	
