extends ScrollContainer

@onready var vbox_node = $HBoxContainer/VBoxContainer

func _ready():
	Logs.add_logs.connect(add_logs)
	Logs.remove_logs.connect(remove_logs)
		
func add_logs(logs:Array):
	if logs.size() > 0:
		var label = preload("res://UI/Logs_Label.tscn").instantiate()
		var animation_player_fade_in = label.get_node("ColorRect_Animation/AnimationPlayer_Fade")
		label.text = logs[0]
		animation_player_fade_in.play("fade_in")
		vbox_node.add_child(label, true)
		vbox_node.move_child(label, 0)
	
func remove_logs():
	if vbox_node.get_child_count() > 0:
		var last_label = vbox_node.get_child(vbox_node.get_child_count() - 1)
		var animation_player_fade_out = last_label.get_node("ColorRect_Animation/AnimationPlayer_Fade")
		animation_player_fade_out.play("fade_out")
		await get_tree().create_timer(1.0).timeout
		if last_label != null:
			last_label.queue_free()
