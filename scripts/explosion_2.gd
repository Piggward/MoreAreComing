extends GPUParticles2D

const BASE_RADIUS = 40

@export var radius: float = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale *= radius / BASE_RADIUS
	var highest_life_time = self.lifetime
	self.emitting = true
	for child in get_children():
		if child is GPUParticles2D:
			child.emitting = true
			if child.lifetime > highest_life_time:
				highest_life_time = child.lifetime
			
	await get_tree().create_timer(highest_life_time).timeout
	self.queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
