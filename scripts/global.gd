extends Node

@export var saving_tree: Array[PowerTree]
@export var has_reloaded = false
@export var player_color: Color

func _ready():
	EventManager.primary_color_change.connect(func(a): self.player_color = a)
