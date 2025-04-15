extends Area2D

func _on_area_exited(area: Area2D) -> void:
	if area is ShootArea and not area.dead:
		area.queue_free()
	pass # Replace with function body.
