extends Node2D

var turret: Turret

# Called when the node enters the scene tree for the first time.
func _ready():
	turret = get_tree().get_first_node_in_group("turret")
	turret.power_spawn.connect(func(p): add_child(p))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
