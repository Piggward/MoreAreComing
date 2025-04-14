class_name Player
extends CharacterBody2D

@export var stats: PowerUp
@export var max_health: int
@export var level_progression: Array[int] = []

var primary_color: Color
var health: int
var turret: Turret
var exp = 0
var current_level = 0
signal attributes_updated
signal health_updated(health: int, max_health: int)

func _ready():
	turret = get_tree().get_first_node_in_group("turret")
	health = max_health
	EventManager.primary_color_change.connect(func(a): self.primary_color = a)
	
func _physics_process(delta: float) -> void:
	if stats.has_automatic_shooting:
		if Input.is_action_pressed("left_click"):
			turret.shoot()
	else:
		if Input.is_action_just_pressed("left_click"):
			turret.shoot()
	
	if Input.is_action_just_pressed("right_click"):
		turret.reload()
	
func take_damage(damage: int):
	self.health -= damage
	health_updated.emit(self.health, self.max_health)
	
	## Move to level
	#if health <= 0:
		#level_1.game_over(false)
	
func update_attributes():
	turret.scale.x = clamp(turret.scale.x, 1, 3)
	turret.scale.y = clamp(turret.scale.y, 1, 3)
	attributes_updated.emit()
