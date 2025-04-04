class_name Turret
extends Node2D

@onready var nozzle: Marker2D = $Nozzle
var player: Player
var shoot_ready: bool = true

const SHOOT_AREA = preload("res://scenes/shoot_area.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.

func shoot():
	if not shoot_ready:
		return
	shoot_ready = false
	var s = SHOOT_AREA.instantiate()
	s.direction = self.rotation - deg_to_rad(90)
	s.speed = player.shoot_speed
	s.global_position = nozzle.global_position
	s.damage = player.damage
	get_parent().add_child(s)
	await get_tree().create_timer(player.shoot_cd).timeout
	shoot_ready = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ro = get_angle_to(get_global_mouse_position())
	var factor = -1 if ro < 0 else 1
	#var add_ro = get_angle_to(get_global_mouse_position()) if ro < 0.005 else get_angle_to(get_global_mouse_position()) * player.turn_rate
	if abs(ro) < player.turn_rate:
		self.rotation += ro
	else:
		self.rotation += player.turn_rate * factor
	pass
