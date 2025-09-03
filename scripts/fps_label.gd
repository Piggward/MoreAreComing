extends Label
@onready var label = $Label

func _ready():
	var em: EnemyManager = get_tree().get_first_node_in_group("enemy_manager")
	em.enemies_updated.connect(on_enemy_updated)
	
func on_enemy_updated(em: Array[Enemy]):
	var he = em.filter(func(a: Enemy): return a.part_of_horde).size()
	var re = em.size() - he
	label.text = "random enemies: " + str(re) + " \n horde enemies: " + str(he)
	
func _process(delta: float) -> void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	var frame_time = delta * 1000.0 # ms
	var draw_calls = Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)
	var static_mem = Performance.get_monitor(Performance.MEMORY_STATIC) / 1024 / 1024 # MB

	text = "FPS: %d\nFrame Time: %.2f ms\nDraw Calls: %d\nMemory: %.2f MB" % [
		fps, frame_time, draw_calls, static_mem
	]
