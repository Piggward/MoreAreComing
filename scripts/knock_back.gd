class_name KnockBackNode
extends Node

@export var time: float
@export var knock_back_speed: float
@export var direction: Vector2
var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.start(time)
	timer.timeout.connect(end_knockback)
	pass # Replace with function body.

func end_knockback():
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer:
		print(timer.time_left)
	var enemy = get_parent()
	enemy.position += direction * knock_back_speed * delta
	pass
