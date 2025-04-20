extends GPUParticles2D
@export var min_scale: float
@export var enabled : bool:
	set(value):
		enabled = value
		if is_inside_tree():
			emit(global_transform)
		last_emitted = Time.get_ticks_usec()
	get:
		return enabled
var old_transform : Transform3D
var old_transform_time : int
var last_emitted : int

func _ready():
	if not get_parent().get_parent().is_node_ready():
		await get_parent().get_parent().ready
	self.set_amount(get_parent().get_parent().power.speed)
	self.set_amount(100)
	print(amount)
	self.process_material.set("scale", Vector2(min_scale * get_parent().get_parent().scale.x, min_scale * get_parent().get_parent().scale.y));
	pass

func _process(delta: float) -> void:
	if not enabled:
		return
	var current_time = Time.get_ticks_usec()
	if not old_transform:
		old_transform = global_transform
		old_transform_time = current_time - 1
	var emit_time = lifetime * 1_000_000 / amount * 1.1
	while last_emitted + emit_time < current_time:
		last_emitted += emit_time
		var w = inverse_lerp(old_transform_time, current_time, last_emitted)
		emit(old_transform.interpolate_with(global_transform, w))
	old_transform = global_transform
	old_transform_time = current_time

func emit(t : Transform2D):
	emit_particle(t, Vector2(), Color(), Color(), EMIT_FLAG_POSITION)
