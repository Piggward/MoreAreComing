extends Label

@onready var enemy_manager = $"../../../../EnemyManager"
var killed = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_manager.enemy_killed.connect(_on_killed)
	self.text = "ENEMIES KILLED: " + str(killed)
	pass # Replace with function body.

func _on_killed():
	killed += 1
	self.text = "ENEMIES KILLED: " + str(killed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
