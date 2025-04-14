extends CanvasLayer

@onready var ui: Control = $UI
@onready var exit_shop_button: Control = $ExitShopButton

func _ready():
	EventManager.start_game.connect(_on_game_start)
	EventManager.exit_shop.connect(_on_exit_shop)
	
func _on_exit_shop():
	exit_shop_button.visible = false
	
func _on_game_start():
	ui.visible = true
