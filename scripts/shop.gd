class_name Shop
extends HBoxContainer

const SHOP_ITEM = preload("res://scenes/shop_item.tscn")
@export var power_ups: Array[PowerUpTree]
@onready var animation_player = $"../AnimationPlayer"
@onready var panel_container = $"../PanelContainer"
@onready var power_up_description = $"../PanelContainer/MarginContainer/PowerUpDescription"
@onready var power_up = $"../../Turret/CharacterBody2D/PowerUp"
@onready var exit_shop_button: Button = $"../ExitShopButton"

var opening_door = false
var current: Array[PowerUp] = []

signal exit_shop

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	if Global.has_reloaded:
		power_ups = Global.saving_tree
	else:
		var arr: Array[PowerUpTree] = []
		for n in power_ups:
			arr.append(n.duplicate(true))
			Global.saving_tree  = arr
	pass # Replace with function body.

func provide_powerups():
	self.visible = true
	current = []
	var eras: Array[PowerUpTree] = []
	for p in power_ups:
		if p.powerups.is_empty():
			eras.append(p)
	for d in eras:
		power_ups.erase(d)
	power_ups.shuffle()
	var fpp = power_ups.filter(func(a): return a.powerups[0].title == "POWER")
	var fp = power_ups.filter(func(a): return a.powerups[0].title == "GREASE")
	var fb = power_ups.filter(func(a): return a.powerups[0].title == "BURST")
	var ff = power_ups.filter(func(a): return a.powerups[0].title == "FINESSE")
	if fpp.size() == 1:
		power_ups.find(fpp[0])
		power_ups.remove_at(power_ups.find(fpp[0]))
		power_ups.push_front(fpp[0])
	if fp.size() == 1:
		power_ups.find(fp[0])
		power_ups.remove_at(power_ups.find(fp[0]))
		power_ups.push_front(fp[0])
	if fb.size() == 1:
		power_ups.find(fb[0])
		power_ups.remove_at(power_ups.find(fb[0]))
		power_ups.push_front(fb[0])
	if ff.size() == 1:
		power_ups.find(ff[0])
		power_ups.remove_at(power_ups.find(ff[0]))
		power_ups.push_front(ff[0])
	for i in 3:
		add_powerup()
		
func _on_door_opened(si: ShopItem):
	if opening_door:
		return
	opening_door = true
	for child in get_children():
		if child != si:
			child.visible = false
			
	si.open_door()
	for i in power_ups.size():
		if power_ups[i].powerups.any(func(a): return a.title == si.power_up.title):
			power_ups[i].powerups.pop_front()

	power_up_description.text = si.power_up.power_up_description
	animation_player.play("show_powerup")
	si.power_up.apply(get_tree().get_first_node_in_group("player"))
	await animation_player.animation_finished
	exit_shop_button.visible = true
	opening_door = false
	
func leave_shop():
	panel_container.visible = false
	for child in get_children():
		child.queue_free()
	self.visible = false
	exit_shop_button.visible = false
	
func add_powerup():
	var p = SHOP_ITEM.instantiate()
	var pup_tree = power_ups.pop_front()
	var pup = pup_tree.powerups[0]
	current.append(pup)
	p.power_up = pup
	p.door_open.connect(_on_door_opened)
	add_child(p)
	power_ups.push_back(pup_tree)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_shop_button_button_up() -> void:
	exit_shop.emit()
	leave_shop()
	pass # Replace with function body.
