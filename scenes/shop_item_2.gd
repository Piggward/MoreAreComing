class_name ShopItem
extends PanelContainer

@export var power_up: PowerUp
@onready var on_hover_panel = $OnHoverPanel
@onready var texture = $MarginContainer/PanelContainer/Vbox/Texture
@onready var description = $MarginContainer/PanelContainer/Vbox/DescriptionContainer/Description
@onready var title = $MarginContainer/PanelContainer/Vbox/TitleContainer/Title

signal selected(si: ShopItem)

# Called when the node enters the scene tree for the first time.
func _ready():
	on_hover_panel.visible = false
	title.text = power_up.title
	description.text = power_up.power_up_description
	texture = power_up.texture
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
