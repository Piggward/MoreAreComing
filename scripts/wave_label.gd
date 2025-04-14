class_name WaveLabel
extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "STAGE LEVEL 1"
	EventManager.next_wave.connect(func(a): text = "STAGE LEVEL " + str(a))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
