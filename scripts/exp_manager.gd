class_name ExpManager
extends Node2D

@export var exp_wait_time: float
const RUMBLE_NODE = preload("res://scenes/rumble_node.tscn")
const UPGRADE_PARTICLES = preload("res://vfx/upgrade_particles.tscn")
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_spawn_exp)
	#await_exp()
	pass # Replace with function body.

func await_exp():
	timer.start(1)
	
func _spawn_exp():
	var rand_x = randf_range(100, 300)
	var rand_y = randf_range(100, 300)
	rand_x *= -1 if randi_range(0, 1) == 0 else 1
	rand_y *= -1 if randi_range(0, 1) == 0 else 1
	var rn = RUMBLE_NODE.instantiate()
	rn.destination = Vector2(rand_x, rand_y)
	rn.position = Vector2(rand_x, -1500)
	add_child(rn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
