class_name Player
extends CharacterBody2D

@export var stats: PowerUp
@export var max_health: int
@export var level_progression: Array[int] = []
@export var powers: Array[Power]
@export var basic_power: Power

var power_timers = { }
var primary_color: Color
var health: int
var turret: Turret
var enemy_manager: EnemyManager
var exp = 0
var current_level = 0

signal attributes_updated
signal health_updated(health: int, max_health: int)
signal level_up(level: int)

func _ready():
	EventManager.exp_pickup.connect(_on_exp_pickup)
	turret = get_tree().get_first_node_in_group("turret")
	enemy_manager = get_tree().get_first_node_in_group("enemy_manager")
	enemy_manager.enemy_killed.connect(_on_enemy_killed)
	health = max_health
	EventManager.primary_color_change.connect(func(a): self.primary_color = a)
	for p in powers:
		connect_power_timer(p)
		
func connect_power_timer(p: Power):
	p.timer = Timer.new()
	power_timers[p.timer] = p
	add_child(p.timer)
	p.timer.timeout.connect(func(): power_time(p.timer))
	p.timer.start(p.cool_down)
	
func power_time(timer: Timer):
	var power = power_timers[timer]
	turret.spawn_power(power)
	timer.start(power.cool_down)
	pass
	
func _physics_process(delta: float) -> void:
	if stats.has_automatic_shooting:
		if Input.is_action_pressed("left_click"):
			turret.shoot(basic_power)
	else:
		if Input.is_action_just_pressed("left_click"):
			turret.shoot(basic_power)
	
	if Input.is_action_just_pressed("right_click"):
		turret.reload()
		
func _on_exp_pickup(value: int):
	exp += value
	EventManager.experience_added.emit(exp)
	if current_level + 1 >= level_progression.size():
		return
	if exp >= level_progression[current_level]:
		current_level += 1
		level_up.emit(current_level)
		exp = 0
		EventManager.experience_updated.emit(0, level_progression[current_level])
		
func _on_enemy_killed(enemy: Enemy):
	_on_exp_pickup(enemy.exp)
	
func take_damage(damage: int):
	self.health -= damage
	health_updated.emit(self.health, self.max_health)
	
func update_attributes():
	turret.scale.x = clamp(turret.scale.x, 1, 3)
	turret.scale.y = clamp(turret.scale.y, 1, 3)
	attributes_updated.emit()
