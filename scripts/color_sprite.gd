extends Sprite2D

@export var tolerance = 0.15
@export var should_change_color: bool = true
@export var glow: float = 2

func _ready(): 
	set_color(Global.player_color)

func set_color(color: Color):
	var b = color.b * glow
	var r = color.r * glow
	var g = color.g * glow
	self.material.set("shader_param/new_primary_color", Color(r, g, b))
	self.material.set("shader_param/tolerance", tolerance)
