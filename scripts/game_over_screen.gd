class_name GameOverScreen
extends Control

@export var won: bool = false
@onready var label = $PanelContainer/MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	if won:
		label.text = "YOU WON!"
	else:
		label.text = "GAME OVER!"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_try_again_button_button_down():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	pass # Replace with function body.


func _on_quit_button_button_down():
	get_tree().quit()
	pass # Replace with function body.
