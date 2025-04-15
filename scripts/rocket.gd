extends ShootArea

const ROCKET = preload("res://scenes/rocket.tscn")

var aoe: Aoe
@export var radius: float

func _ready():
	super._ready()
	aoe = Aoe.new()
	self.add_child(aoe)
	

#func on_hit(enemy: Enemy):
	#for area in aoe.get_overlapping_areas():
		#if area is Enemy:
			#area.take_damage(damage)
	#terminate_self()
	
func get_instance():
	var rocket = ROCKET.instantiate()
	rocket.damage = self.damage
	rocket.speed = self.speed
	rocket.radius = self.radius
	return rocket
