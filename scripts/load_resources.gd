extends Node2D

@onready var explosion_particles = $ExplosionParticles

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	pass # Replace with function body.

func check_node(node: Node):
	if node.get_child_count() > 0:
		check_children(node.get_children())
	
	if not node.is_node_ready():
		await node.ready

func check_children(nodes: Array[Node]): 
	for node in nodes:
		check_node(node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
