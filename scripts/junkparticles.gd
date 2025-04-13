class_name Junk
extends GPUParticles2D

enum JUNKTYPE {SCREW, ROUND, PLATE, NAIL, WHEEL}

@export var junktype: JUNKTYPE
const SCREWS = preload("res://art/genericItem_color_018.png")
const NAILS = preload("res://art/genericItem_color_019.png")
const PLATES = preload("res://art/genericItem_white_069.png")
const ROUNDSCREW = preload("res://art/genericItem_white_096.png")
const WHEEL = preload("res://art/genericItem_white_147.png")
var custom_amount: int

# Called when the node enters the scene tree for the first time.
func _ready():
	match junktype:
		self.JUNKTYPE.SCREW:
			custom_amount = randi_range(5, 8)
			self.texture = SCREWS
			print("SPAWNING " + str(amount) + " SCREWS")
		self.JUNKTYPE.ROUND:
			custom_amount = randi_range(3, 5)
			self.scale *= 1
			self.texture = ROUNDSCREW
			print("SPAWNING " + str(amount) + " ROUNDSCREW")
		self.JUNKTYPE.NAIL:
			custom_amount = randi_range(5, 8)
			self.texture = NAILS
			print("SPAWNING " + str(amount) + " NAILS")
		self.JUNKTYPE.PLATE:
			self.scale *= 2.5
			self.texture = PLATES
			self.amount = randi_range(0, 1)
			print("SPAWNING " + str(amount) + " PLATES")
	self.amount = custom_amount
	self.emitting = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
