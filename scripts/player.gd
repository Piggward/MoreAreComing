class_name Player
extends CharacterBody2D

var turret: Turret
@export var shoot_speed: float
@export var knock_back: float = 1
@export var damage: float
@export var turn_rate: float
@export var mag_size: int
@export var reload_speed: float
@export var shoot_cd: float
@export var shot_scale: float = 1
@export var aoe: float
@export var pierce: int = 0
@onready var power_up = $PowerUp
@export var health: int
@export var colors: Array[Color]
var primary_color: Color
var has_automatic_reload = true
var has_automatic_shooting = true
@onready var shop = $"../CanvasLayer/Shop"
@onready var health_label = $"../CanvasLayer/ProgressBar/HealthLabel"
@onready var progress_bar = $"../CanvasLayer/ProgressBar"
@onready var level_1 = $".."
@export var level_progression: Array[int] = []
var exp = 0
var current_level = 0
signal attributes_updated
@onready var turret_sprite = $"../Turret/TurretSprite"

func _ready():
	progress_bar.max_value = health
	progress_bar.value = self.health
	health_label.text = str(health) + " / " + str(health)
	if not turret_sprite.ready:
		await turret_sprite.is_node_ready()
	primary_color = turret_sprite.material.get_shader_parameter("primary_color")
	turret = get_tree().get_first_node_in_group("turret")
	
func change_color(color):
	turret_sprite.material.set("shader_param/new_primary_color", color) 
	turret_sprite.material.set("shader_param/tolerance", 0.15)
	primary_color = color
	
func next_color():
	var color = colors.pop_front()
	colors.push_back(color)
	change_color(color)
	
func _physics_process(delta: float) -> void:
	if shop.visible:
		return
	
	if has_automatic_shooting:
		if Input.is_action_pressed("left_click"):
			turret.shoot()
	else:
		if Input.is_action_just_pressed("left_click"):
			turret.shoot()
	
	if Input.is_action_just_pressed("right_click"):
		turret.reload()
	
func take_damage(damage: int):
	self.health -= damage
	progress_bar.value = self.health
	health_label.text = str(health) + " / " + str(progress_bar.max_value)
	if health <= 0:
		level_1.game_over(false)
	
	

func update_attributes():
	turret.scale.x = clamp(turret.scale.x, 1, 3)
	turret.scale.y = clamp(turret.scale.y, 1, 3)
	attributes_updated.emit()
