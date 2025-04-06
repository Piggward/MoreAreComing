class_name ShopItem
extends VBoxContainer

@export var power_up: PowerUp
@onready var power_up_label = $LabelPanelContainer/MarginContainer/PowerUpLabel
@onready var bonus_label = $DoorPanelContainer/MarginContainer/BonusContainer/MarginContainer/BonusLabel
var disappear = false
@onready var door_texture_rect = $DoorPanelContainer/MarginContainer/DoorTextureRect
@onready var label_panel_container = $LabelPanelContainer
@onready var door_on_hover_panel = $DoorPanelContainer/MarginContainer/DoorOnHoverPanel
@onready var open_door_texture_rect = $DoorPanelContainer/MarginContainer/OpenDoorTextureRect
@onready var bonus_container = $DoorPanelContainer/MarginContainer/BonusContainer
@onready var open_door_sound = $OpenDoorSound
@onready var knock_door_sound = $KnockDoorSound
var has_knocked = false

signal door_open(sh: ShopItem)

# Called when the node enters the scene tree for the first time.
func _ready():
	power_up_label.text = power_up.title
	var randstr = str(randi())
	power_up_label.add_theme_color_override("font_color", power_up.title_color)
	bonus_label.text = power_up.power_up_description
	bonus_container.visible = false
	door_on_hover_panel.visible = false
	door_texture_rect.visible = true
	open_door_texture_rect.visible = false
	pass # Replace with function body.
	
func open_door():
	door_texture_rect.visible = false
	open_door_texture_rect.visible = true
	door_on_hover_panel.visible = false
	open_door_sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disappear:
		door_texture_rect.self_modulate.a -= 0.009
		label_panel_container.self_modulate.a = door_texture_rect.self_modulate.a
		if door_texture_rect.self_modulate.a <= 0:
			self.queue_free()
	pass

func _on_door_texture_rect_mouse_entered():
	door_on_hover_panel.visible = true
	pass # Replace with function body.


func _on_door_texture_rect_mouse_exited():
	door_on_hover_panel.visible = false
	pass # Replace with function body.

func _on_door_texture_rect_gui_input(event):
	if event.is_action_pressed("left_click") and not has_knocked:
		has_knocked = true
		knock_door_sound.play()
		door_open.emit(self)
	pass # Replace with function body.
