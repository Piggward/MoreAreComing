extends Marker2D
@onready var shoot_light = $Shoot_light
var cd = false
const TIME = 0.085
var ctime = 0.0
const MUZZLE_02 = preload("res://art/muzzle_02.png")
const MUZZLE_04 = preload("res://art/muzzle_04.png")
var arr: Array[Texture]
@onready var sprite_2d = $Node2D/Sprite2D
@onready var node_2d = $Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	arr.append(MUZZLE_02)
	arr.append(MUZZLE_04)
	pass # Replace with function body.

func light():
	if cd:
		return
	#shoot_light.visible = true
	var rand = randi_range(0, 1)
	var rand_s = randf_range(0.7, 1.4)
	sprite_2d.texture = arr[rand]
	node_2d.scale = Vector2(1, 1)
	node_2d.scale *= rand_s
	sprite_2d.visible = true
	cd = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cd: 
		ctime += delta
		if ctime > TIME: 
			shoot_light.visible = false
			sprite_2d.visible = false
			cd = false
			ctime = 0
	pass
