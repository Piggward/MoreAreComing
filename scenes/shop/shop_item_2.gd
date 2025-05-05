class_name ShopItem
extends PanelContainer

@export var power_up: PowerUp
@export var new: bool = true
@onready var on_hover_panel = $OnHoverPanel
@onready var description = $MarginContainer/PanelContainer/Vbox/DescriptionContainer/Description
@onready var title = $MarginContainer/PanelContainer/Vbox/TitleContainer/Title
@onready var margin_container = $MarginContainer/PanelContainer/Vbox/MarginContainer
@onready var texture = $MarginContainer/PanelContainer/Vbox/MarginContainer/Texture

signal selected(si: ShopItem)

# Called when the node enters the scene tree for the first time.
func _ready():
	on_hover_panel.visible = false
	title.text = power_up.starting_power.get_power_name()
	title.text += " (NEW)" if new else ""
	description.text = power_up.get_description() if not new else power_up.starting_power.get_general_description()
	var new_texture = power_up.starting_power.get_texture()
	if new_texture.should_change_color:
		new_texture.set_color(Global.player_color)
	margin_container.add_child(new_texture)
	texture.queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	on_hover_panel.visible = true
	pass # Replace with function body.


func _on_mouse_exited():
	on_hover_panel.visible = false
	pass # Replace with function body.


func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit(self)
	pass # Replace with function body.
