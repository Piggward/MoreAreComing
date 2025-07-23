class_name TestEnemyManager
extends Node2D

const NORMAL_ENEMY = preload("res://scenes/enemies/enemy.tscn")
const ORBIT_ENEMY = preload("res://scenes/enemies/orbit_enemy.tscn")
const ZIG_ZAG_ENEMY = preload("res://scenes/enemies/plane_enemy.tscn")
const ENEMIES_PER_RING = 8  # Can vary per ring if you want
const RING_DISTANCE = 50    # Distance between rings (can be your D)
const JITTER_AMOUNT = 25  # Max pixels to jitter
const SPAWN_RADIUS = 800
const SPAWN_RADIUS_SPREAD = 0.3
const RUMBLE_AREA = preload("res://scenes/rumble_area.tscn")

var alive_enemies: Array[Enemy] = []
@export var current_wave: Wave
var player_pos: Vector2
var horde_timer: Timer
var random_enemy_timer: Timer
var spawning_enemies: bool = false
var spawning_horde: bool = false
var enemy_dict = {}

enum ENEMYTYPE { NORMAL, ZIG_ZAG, ORBIT }

signal enemy_killed(enemy: Enemy)

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	var level = get_tree().get_first_node_in_group("level")
	#level.new_wave.connect(_on_new_wave)
	#current_wave = level.waves[0]
	player_pos = player.position
	#horde_timer = Timer.new()
	#horde_timer.timeout.connect(_on_horde_timer_timeout)
	#add_child(horde_timer)
	#random_enemy_timer = Timer.new()
	#random_enemy_timer.timeout.connect(_on_random_enemy_timer_timeout)
	#add_child(random_enemy_timer)
	instantiate_enemy_dict()
	#EventManager.start_game.connect(game_start)
	
func instantiate_enemy_dict():
	enemy_dict = {
		ENEMYTYPE.NORMAL: NORMAL_ENEMY,
		ENEMYTYPE.ZIG_ZAG: ZIG_ZAG_ENEMY,
		ENEMYTYPE.ORBIT: ORBIT_ENEMY
	}

func game_start():
	_on_horde_timer_timeout()
	_on_random_enemy_timer_timeout()
	spawn_initial_enemies()
	
func spawn_initial_enemies():
	for i in 1:
		var angle = randf() * TAU
		var random_pos = player_pos + Vector2(random_spawn_radius() / 2, 0).rotated(angle)
		var jitter = Vector2(randf_range(-JITTER_AMOUNT, JITTER_AMOUNT),
						 randf_range(-JITTER_AMOUNT, JITTER_AMOUNT))
		spawn_enemy(random_pos + jitter, false, ENEMYTYPE.NORMAL)
	
func _on_random_enemy_timer_timeout():
	spawn_random_enemy(ENEMYTYPE.NORMAL)
	var timer = Timer.new()
	for i in current_wave.target_random_enemies_amount - alive_random_enemies():
		var rand_time = randf_range(0.5, 1.0)
		add_child(timer)
		timer.start(rand_time)
		await timer.timeout
		#print("spawning random enemy " + str(i))
		spawn_random_enemy(ENEMYTYPE.NORMAL)
	var offset = current_wave.random_enemy_spawn_cd * 0.15
	var rand = randf_range(current_wave.random_enemy_spawn_cd - offset, current_wave.random_enemy_spawn_cd + offset)
	timer.queue_free()
	random_enemy_timer.start(rand)
	pass
	
func alive_random_enemies():
	return alive_enemies.filter(func(a: Enemy): return not a.part_of_horde).size()
	
func alive_horde_enemies():
	return alive_enemies.filter(func(a: Enemy): return a.part_of_horde).size()
	
func _on_horde_timer_timeout():
	spawn_horde()
	var offset = current_wave.horde_spawn_cd * 0.15
	var rand = randf_range(current_wave.horde_spawn_cd - offset, current_wave.horde_spawn_cd + offset)
	horde_timer.start(rand)
	pass
	
func _on_new_wave(wave: Wave):
	print("new wave")
	current_wave = wave
	
func random_spawn_radius():
	var rand = 1 - randf_range(-SPAWN_RADIUS_SPREAD, SPAWN_RADIUS_SPREAD)
	return SPAWN_RADIUS * rand

func spawn_horde():
	print("spawning horde")
	var D = 75
	# Step 1: Pick random direction and find horde center
	var angle = randf() * TAU
	var horde_center = player_pos + Vector2(random_spawn_radius(), 0).rotated(angle)
	var spawned = 0
	var ring = 1
	while spawned < current_wave.horde_amount:
		var enemies_in_ring = min(ENEMIES_PER_RING * ring, current_wave.horde_amount - spawned)
		for i in range(enemies_in_ring):
			var ring_angle = TAU * i / enemies_in_ring
			var radius = ring * D
			var offset = Vector2(radius, 0).rotated(ring_angle)

			# Add jitter: random Vector2 with small x/y offsets
			var jitter = Vector2(randf_range(-JITTER_AMOUNT, JITTER_AMOUNT),
								 randf_range(-JITTER_AMOUNT, JITTER_AMOUNT))
			var enemy_pos = horde_center + offset + jitter
			spawn_enemy(enemy_pos, true, ENEMYTYPE.NORMAL)

			spawned += 1
			if spawned >= current_wave.horde_amount:
				break
		ring += 1
		
func spawn_random_enemy(type: ENEMYTYPE):
	var angle = randf() * TAU
	var random_pos = player_pos + Vector2(random_spawn_radius(), 0).rotated(angle)
	var jitter = Vector2(randf_range(-JITTER_AMOUNT, JITTER_AMOUNT),
					 randf_range(-JITTER_AMOUNT, JITTER_AMOUNT))
	spawn_enemy(random_pos + jitter, false, type)
		
func spawn_enemy(pos, part_of_horde, type: ENEMYTYPE):
	var enemy = enemy_dict[type].instantiate()
	var speed_offset = randf_range(0.8, 1.2)
	var es = current_wave.speed * speed_offset
	enemy.speed = es if not part_of_horde else es * 0.7
	enemy.damage = current_wave.damage
	enemy.max_health = current_wave.health
	enemy.died.connect(_on_enemy_died)
	enemy.position = pos
	enemy.part_of_horde = part_of_horde
	alive_enemies.append(enemy)
	#print("target random enemies: " + str(current_wave.target_random_enemies_amount))
	#print("random enemies: " + str(alive_random_enemies()))
	#print("horde enemies: " + str(alive_horde_enemies()))
	#print("total enemies: " + str(alive_enemies.size()))
	add_child(enemy)
	
func _on_enemy_died(enemy: Enemy):
	alive_enemies.erase(enemy)
	enemy_killed.emit(enemy)
	_spawn_exp(enemy)
	if enemy.part_of_horde:
		horde_enemy_died()
		
func _spawn_exp(enemy: Enemy):
	var rand = randf_range(0.0, 1.0)
	if enemy.exp <= 0 or enemy.exp_chance < rand:
		return
	var rn = RUMBLE_AREA.instantiate()
	rn.exp_worth = enemy.exp
	rn.position = enemy.global_position - self.global_position
	add_child(rn)
	
func horde_enemy_died():
	var alive = alive_horde_enemies()
	var threshold = float((current_wave.horde_amount * current_wave.target_hordes)) * 0.2
	if spawning_horde or alive > threshold:
		return
	spawning_horde = true
	
	horde_timer.stop()
	
	var rand_time = randf_range(0.5, 2.0)
	await get_tree().create_timer(rand_time).timeout
	spawn_horde()
		
	horde_timer.start(current_wave.horde_spawn_cd)
	spawning_horde = false
		
