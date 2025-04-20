class_name EnemyManager
extends Node2D

const ENEMY = preload("res://scenes/enemy.tscn")
const SPEEDY_ENEMY = preload("res://scenes/speedy_enemy.tscn")
const TANKY_ENEMY = preload("res://scenes/tanky_enemy.tscn")
const ENEMIES_PER_RING = 8  # Can vary per ring if you want
const RING_DISTANCE = 50    # Distance between rings (can be your D)
const JITTER_AMOUNT = 25  # Max pixels to jitter
const SPAWN_RADIUS = 700

var first = true

signal enemy_killed(enemy: Enemy)

func spawn_horde(player_pos, wave, amount):
	var D = 75
	# Step 1: Pick random direction and find horde center
	var angle = randf() * TAU
	var horde_center = player_pos + Vector2(SPAWN_RADIUS, 0).rotated(angle)
	if first:
		horde_center = player_pos + Vector2(420, 0).rotated(angle)
		first = false

	var spawned = 0
	var ring = 1
	while spawned < amount:
		var enemies_in_ring = min(ENEMIES_PER_RING * ring, amount - spawned)
		for i in range(enemies_in_ring):
			var ring_angle = TAU * i / enemies_in_ring
			var radius = ring * D
			var offset = Vector2(radius, 0).rotated(ring_angle)

			# Add jitter: random Vector2 with small x/y offsets
			var jitter = Vector2(randf_range(-JITTER_AMOUNT, JITTER_AMOUNT),
								 randf_range(-JITTER_AMOUNT, JITTER_AMOUNT))
			var enemy_pos = horde_center + offset + jitter
			spawn_enemy(wave, enemy_pos)

			spawned += 1
			if spawned >= amount:
				break
		ring += 1
		
func spawn_random_enemy(player_pos, wave):
	var angle = randf() * TAU
	var random_pos = player_pos + Vector2(SPAWN_RADIUS, 0).rotated(angle)
	var jitter = Vector2(randf_range(-JITTER_AMOUNT, JITTER_AMOUNT),
					 randf_range(-JITTER_AMOUNT, JITTER_AMOUNT))
	spawn_enemy(wave, random_pos + jitter)
		
func spawn_enemy(wave, pos):
	var enemy = ENEMY.instantiate()
	enemy.speed = wave.speed
	enemy.damage = wave.damage
	enemy.max_health = wave.health
	enemy.died.connect(_on_enemy_died)
	enemy.position = pos
	add_child(enemy)
	
func _on_enemy_died(enemy: Enemy):
	enemy_killed.emit(enemy)
