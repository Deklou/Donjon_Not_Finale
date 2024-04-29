extends CanvasLayer

func _ready():
	EntitiesState.hide_UI.connect(hide_UI)

func hide_UI():
	$".".visible = false

func show_UI():
	$".".visible = true
