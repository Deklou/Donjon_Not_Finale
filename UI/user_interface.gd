extends CanvasLayer


func _ready():
	StatsSystem.hide_UI.connect(hide_UI)

func hide_UI():
	$".".visible = false

func show_UI():
	$".".visible = true
