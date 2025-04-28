extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	var player: Player = get_tree().get_first_node_in_group("player")
	collision_shape_2d.shape.radius = player.stats.shoot_range / 2

func _on_area_exited(area: Area2D) -> void:
	if area is ShootArea and not area.dead:
		area.on_out_of_bounds()
	pass # Replace with function body.
