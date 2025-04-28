class_name Player
extends CharacterBody2D

@export var stats: TurretStats
@export var max_health: int
@export var level_progression: Array[int] = []
@export var powers: Array[Power]
@export var basic_power: BasicPower

var power_timers = { }
var primary_color: Color
var health: int
var turret: Turret
var exp = 0
var current_level = 0
var shoot_ready = true

signal attributes_updated
signal health_updated(health: int, max_health: int)
signal level_up(level: int)

func _ready():
	EventManager.exp_pickup.connect(_on_exp_pickup)
	turret = get_tree().get_first_node_in_group("turret")
	health = max_health
	EventManager.primary_color_change.connect(func(a): self.primary_color = a)
	EventManager.start_game.connect(_on_game_start)
	connect_basic_power_timer()
	
func _on_game_start():
	for p in powers:
		connect_power_timer(p)
	
func connect_basic_power_timer():
	basic_power.create_timer()
	add_child(basic_power.timer)
	
func add_power(power: Power):
	powers.append(power)
	connect_power_timer(power)
	
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
			shoot()
	else:
		if Input.is_action_just_pressed("left_click"):
			shoot()
	
	if Input.is_action_just_pressed("right_click"):
		turret.reload()
		
func shoot():
	if not basic_power.can_shoot() or turret.reloading:
		return
	basic_power.on_shoot()
	turret.shoot(basic_power)
		
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
	
func take_damage(damage: int):
	self.health -= damage
	health_updated.emit(self.health, self.max_health)
	
func update_attributes():
	attributes_updated.emit()
