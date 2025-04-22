extends Area2D

func _on_area_exited(area: Area2D) -> void:
	if area is ShootArea and not area.dead:
		area.on_out_of_bounds()
	pass # Replace with function body.
