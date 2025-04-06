class_name Player
extends CharacterBody2D

@onready var turret: Turret = $".."
@export var shoot_speed: float
@export var knock_back: float = 1
@export var damage: float
@export var turn_rate: float
@export var mag_size: int
@export var reload_speed: float
@export var shoot_cd: float
@export var aoe: float
@export var pierce: int = 0
@onready var power_up = $PowerUp
@export var health: int
@onready var sprite_2d_2 = $"../Sprite2D2"
var has_automatic_reload = false
var has_automatic_shooting = false
@onready var shop = $"../../CanvasLayer/Shop"
@onready var health_label = $"../../CanvasLayer/ProgressBar/HealthLabel"
@onready var progress_bar = $"../../CanvasLayer/ProgressBar"
@onready var level_1 = $"../.."
@export var level_progression: Array[int] = []
var current_level = 0

signal attributes_updated

func _ready():
	progress_bar.max_value = health
	progress_bar.value = self.health
	health_label.text = str(health) + " / " + str(health)

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
