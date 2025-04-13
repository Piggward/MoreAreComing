extends Area2D

signal start_game
const EXPLOSION_PARTICLES = preload("res://scenes/explosion_particles.tscn")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	for child in get_children():
		if child is not AudioStreamPlayer2D:
			child.visible = false
	area.queue_free()
	start_game.emit()
	var particles = EXPLOSION_PARTICLES.instantiate()
	particles.emitting = true
	particles.scale *= 2
	particles.global_position = global_position
	var camera = get_tree().get_first_node_in_group("camera")
	camera.add_trauma(100)
	get_parent().add_child(particles)
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished
	self.queue_free()
	pass # Replace with function body.
