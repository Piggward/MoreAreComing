class_name ShootArea
extends Area2D

@export var direction: float
@export var power: Power
@export var player_color: Color
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var particles: Node2D = $Particles

var dead = false
var enemies_hit: Array[Enemy] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_rotate()
	pass # Replace with function body.
	
func self_rotate():
	self.rotation = direction - deg_to_rad(90)

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
	
func on_out_of_bounds():
	power.on_out_of_bounds(self)
	
func _on_area_entered(area: Area2D) -> void:
	if area is Enemy and not dead:
		on_hit(area)
		enemies_hit.append(area)
	pass # Replace with function body.
	
func on_hit(enemy: Enemy):
	power.on_hit(self, enemy)
	
func get_instance():
	pass
	
