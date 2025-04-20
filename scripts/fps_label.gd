extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()
	pass # Replace with function body.
	
func update_label():
	self.text = "FPS: " + str(Engine.get_frames_per_second())
	await get_tree().create_timer(1).timeout
	update_label() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
