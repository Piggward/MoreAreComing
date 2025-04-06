class_name Shop
extends HBoxContainer

const SHOP_ITEM = preload("res://scenes/shop_item.tscn")
@export var power_ups: Array[PowerUp]
@onready var animation_player = $"../AnimationPlayer"
@onready var panel_container = $"../PanelContainer"
@onready var power_up_description = $"../PanelContainer/MarginContainer/PowerUpDescription"
@onready var control = $"../Control"
@onready var power_up = $"../../Turret/CharacterBody2D/PowerUp"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	pass # Replace with function body.

func provide_powerups():
	self.visible = true
	power_ups.shuffle()
	for i in 3:
		add_powerup()
		
func _on_door_opened(si: ShopItem):
	for child in get_children():
		if child != si:
			child.disappear = true
			
	await get_tree().create_timer(1.1).timeout
	si.open_door()
	await get_tree().create_timer(0.85).timeout
	power_up.play()
	power_up_description.text = si.power_up.power_up_description
	animation_player.play("show_powerup")
	si.power_up.apply(get_tree().get_first_node_in_group("player"))
	await animation_player.animation_finished
	await get_tree().create_timer(1).timeout
	control.visible = true
	
func leave_shop():
	panel_container.visible = false
	for child in get_children():
		child.queue_free()
	self.visible = false
	
func add_powerup():
	var p = SHOP_ITEM.instantiate()
	var pup = power_ups.pop_front()
	p.power_up = pup
	p.door_open.connect(_on_door_opened)
	add_child(p)
	pup.amount -= 1
	if pup.amount > 0:
		power_ups.push_back(pup)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
