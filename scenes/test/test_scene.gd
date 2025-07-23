extends Node2D

var player: Player
var turret: Turret

@export var powers: Array[PowerTree]
@onready var enemy_manager = $EnemyManager

const INPUT_TIMER = 0.3
var input = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	turret = get_tree().get_first_node_in_group("turret")
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("1"):
		spawn_power("Powerball")
	if Input.is_action_pressed("2"):
		spawn_power("Spikes")
	if Input.is_action_pressed("3"):
		spawn_power("Forcefield")
	if Input.is_action_pressed("4"):
		spawn_power("Rocket")
	if Input.is_action_pressed("5"):
		spawn_enemy(TestEnemyManager.ENEMYTYPE.NORMAL)
	if Input.is_action_pressed("6"):
		spawn_enemy(TestEnemyManager.ENEMYTYPE.ZIG_ZAG)
	if Input.is_action_pressed("7"):
		spawn_enemy(TestEnemyManager.ENEMYTYPE.ORBIT)
	pass
	
func spawn_enemy(type: TestEnemyManager.ENEMYTYPE):
	if input:
		return
	
	print("spawning: ", type)
	input = true
	enemy_manager.spawn_random_enemy(type)
	await get_tree().create_timer(INPUT_TIMER).timeout
	input = false
		
	
func spawn_power(power_name):
	if input: 
		return
	print("spawning: ", power_name)
	for p in powers:
		if p.starting_power.get_power_name() == power_name:
			turret.spawn_power(p.starting_power)
	input = true
	await get_tree().create_timer(INPUT_TIMER).timeout
	input = false
