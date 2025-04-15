class_name ShootArea
extends Area2D

@export var direction: float
@export var power: Power
@export var player_color: Color
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var particles: Node2D = $Particles

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.rotation = direction - deg_to_rad(90)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not dead:
		power.travel(self, delta)
	pass

func terminate_self():
	self.monitoring = false
	hit_sound.pitch_scale += randf_range(0, 0.04)
	hit_sound.play()
	dead = true
	for child in get_children():
		child.visible = false
	particles.visible = true
	for child in particles.get_children():
		child.emitting = false
		if child.name == "Trail":
			child.enabled = false
		else:
			child.queue_free()
	await hit_sound.finished
	await get_tree().create_timer(1).timeout
	self.queue_free()
	

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		power.on_hit(self, area)
	pass # Replace with function body.
	
func on_hit(enemy: Enemy):
	EventManager.request_camera_shake.emit(3)
	enemy.take_damage(power.damage)
	terminate_self()
	
func get_instance():
	pass
	
