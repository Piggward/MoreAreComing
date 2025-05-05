extends TextureRect

@export var tolerance = 0.15
@export var should_change_color: bool = true

func set_color(color):
	self.material.set("shader_param/new_primary_color", color) 
	self.material.set("shader_param/tolerance", tolerance)
