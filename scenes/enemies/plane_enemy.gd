class_name PlaneEnemy
extends Enemy

@export var frequency: float = 1.5      # how fast it wiggles
@export var amplitude: float = 250.0       # how wide the wiggle is

var target: Player
var time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	speed = 45
	target = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.


func _process(delta: float) -> void:
	if target == null:
		return

	time += delta

	# Direction straight to player
	var to_player = target.global_position - global_position
	var distance = to_player.length()
	if distance < 100:
		speed *= 5
		super(delta)
		speed /= 5
		return

	var dir = to_player.normalized()
	var perp = Vector2(-dir.y, dir.x)

	# Side-to-side oscillation
	var lateral = sin(time * frequency) * amplitude

	# Final direction vector (forward + lateral)
	var move_vec = (dir * speed * delta) + (perp * lateral * delta)

	# Move enemy
	global_position += move_vec

	# Make enemy look in the direction of movement
	if move_vec.length_squared() > 0.001:
		look_at(global_position + move_vec)
