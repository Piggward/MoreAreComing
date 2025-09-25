class_name DamageLabel
extends Label

@export var speed:= 0.5
@export var damage: int
@export var disappear_speed = 0.01

const BIG_DAMAGE = 20
const MEDIUM_DAMAGE = 10
const SMALL_DAMAGE = 5

const BIG_SIZE = 75
const MEDIUM_SIZE = 55
const SMALL_SIZE = 25

const BIG_SPEED = 0.008
const MEDIUM_SPEED = 0.009
const SMALL_SPEED = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(damage)
	var size: int
	if damage > BIG_DAMAGE:
		size = BIG_SIZE
		disappear_speed = BIG_SPEED
	elif damage > MEDIUM_DAMAGE:
		size = MEDIUM_SIZE
		disappear_speed = MEDIUM_SPEED
	else:
		size = SMALL_SIZE
		disappear_speed = SMALL_SPEED
	self.add_theme_font_size_override("font_size", size)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.y -= speed
	self.modulate.a -= disappear_speed
	if self.modulate.a <= 0:
		self.queue_free()
	pass
