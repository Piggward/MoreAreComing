class_name Shop
extends HBoxContainer

@export var power_ups: Array[PowerTree] = []
const SHOP_ITEM = preload("res://scenes/shop/shop_item.tscn")
var player: Player
var has_selected: bool = false
signal exit_shop

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.level_up.connect(_on_level_up)
	self.visible = false
	for p in power_ups:
		p.initialize_powerups()
	pass # Replace with function body.

func _on_level_up(newlevel):
	self.visible = true
	add_powerups()
	
func add_powerups():
	power_ups.shuffle()
	for i in 3:
		var si = SHOP_ITEM.instantiate()
		var pu: PowerUp = power_ups[i].get_random_powerup()
		si.power_up = pu
		si.selected.connect(_on_select)
		add_child(si)

func _on_select(si: ShopItem):
	if has_selected:
		return
		
	has_selected = true
	si.power_up.apply(player)
	_exit_shop()
	has_selected = false
	
func _exit_shop():
	exit_shop.emit()
	self.visible = false
	for child in get_children():
		if child is ShopItem:
			child.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
