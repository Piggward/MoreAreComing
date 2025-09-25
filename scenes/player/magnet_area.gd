class_name MagnetArea
extends Area2D

@onready var magnet_particles = $GPUParticles2D
@export var speed := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var player: Player = get_tree().get_first_node_in_group("player")
	player.magnet_size_updated.connect(func(v): self.scale = v)
	player.magnet_speed_updated.connect(func(s): speed = s)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if monitorable:
		for area in get_overlapping_areas():
			var dir = (global_position - area.global_position).normalized()
			area.global_position += dir * speed
	pass
	
func start():
	self.monitoring = true
	self.monitorable = true
	magnet_particles.emitting = true
	magnet_particles.visible = true
	
func stop():
	self.monitoring = false
	self.monitorable = false
	magnet_particles.emitting = false
	magnet_particles.visible = false
