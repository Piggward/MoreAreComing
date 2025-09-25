class_name ExpDrop
extends Area2D

@export var exp_worth: int
const EXP_PARTICLE_AREA = preload("res://scenes/exp_particle_area.tscn")
@onready var exp_screw = $ExpScrew
@onready var pickup_sound = $PickupSound

var _original_position := Vector2.ZERO
var pickup = false
var player: Player
var reached = false

func _ready():
	_original_position = position
	player = get_tree().get_first_node_in_group("player")
	#self.mouse_entered.connect(_on_area_2d_mouse_entered)

#func _process(delta):
	#if get_overlapping_areas().any(func(a): return a.monitorable) and not reached:
		##var c_local_to_n_global = get_canvas_transform().affine_inverse() * exp_bar.get_global_transform_with_canvas()
		##var n_target_global_position: Vector2 = c_local_to_n_global * (exp_bar.size / 2)
		#if (global_position - player.global_position).length() < 30:
			#print("reached")
			#reached = true
			#EventManager.exp_pickup.emit(exp_worth)
			#exp_screw.visible = false
			#pickup_sound.play()
			#await pickup_sound.finished
			#self.queue_free()
		#global_position = lerp(global_position, player.global_position, 0.04)

#func _on_area_2d_mouse_entered():
	#if pickup:
		#return
	#pickup = true
	#var tween = create_tween()
	#tween.tween_property(exp_screw, "scale", Vector2.ZERO, 1)
	#pass # Replace with function body.




func _on_area_entered(area):
	EventManager.exp_pickup.emit(exp_worth)
	exp_screw.visible = false
	pickup_sound.play()
	await pickup_sound.finished
	self.queue_free()
