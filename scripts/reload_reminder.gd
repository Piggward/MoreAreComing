extends PanelContainer

var turret: Turret

func _ready():
	turret = get_tree().get_first_node_in_group("turret")
	turret.ammo_updated.connect(_on_ammo_updated)
	turret.reload_started.connect(_on_reload_started)
	
func _on_ammo_updated(ammo_left, mag_size):
	if ammo_left == 0:
		self.visible = true
		
func _on_reload_started():
	self.visible = false
