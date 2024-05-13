extends Node2D

var Root = null
var Root_instance = null
@onready var user_interface_node : CanvasLayer = $User_Interface

func _ready(): #premier appel du jeu, le joueur commence au niveau 0
	user_interface_node.visible = false
	Root = get_tree().root
	Root_instance = preload("res://Menu/stats_screen.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	Root_instance.to_intro_level.connect(_to_intro_level)
	GameState.restart_root.connect(_to_intro_level)
	
func _to_intro_level():	
	if Root.has_node("stats_screen"):
		var lvl = Root.get_node("stats_screen")
		Root.remove_child.call_deferred(lvl)
		lvl.queue_free()
	user_interface_node.visible = true
	Root = get_tree().root
	Root_instance = preload("res://Levels/Demo/Tutorial.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	#Root_instance.to_first_floor.connect(_to_first_floor)
	
func _to_first_floor():
	EntitiesState.enemy_triggered_list.clear()
	EntitiesState.enemy_turn_ended_list.clear()
	if Root.has_node("intro_level"):
		var lvl = Root.get_node("intro_level")
		Root.remove_child.call_deferred(lvl)
		lvl.queue_free()
	user_interface_node.visible = false
	var lvl_2 = preload("res://Transition/intro_to_first_floor.tscn").instantiate()
	Root.add_child.call_deferred(lvl_2)
	await get_tree().create_timer(4.0).timeout
	lvl_2.queue_free()
	user_interface_node.visible = true
	Root = get_tree().root
	Root_instance = preload("res://Levels/demo/first_floor.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	Root_instance.to_the_end.connect(_to_the_end)
	Root_instance.to_secret.connect(_to_secret)
	
func _to_the_end():
	if Root.has_node("first_floor"):
		var lvl = Root.get_node("first_floor")
		Root.remove_child.call_deferred(lvl)
		lvl.queue_free()
	user_interface_node.visible = false
	Root = get_tree().root
	Root_instance = preload("res://Menu/stats_screen.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	GameState.ending_triggered = true
	
func _to_secret():
	if Root.has_node("first_floor"):
		var lvl = Root.get_node("first_floor")
		Root.remove_child.call_deferred(lvl)
		lvl.queue_free()
	Root = get_tree().root
	GameData.secret_triggered = true
	Root_instance = preload("res://Levels/demo/secret.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	GameState.ending_triggered = true
	
func _load_next_level(scene_path : String):
	if EntitiesState.player_parent_node != null:
		Root = get_tree().root
		Root.remove_child.call_deferred(EntitiesState.player_parent_node)
		EntitiesState.player_parent_node.queue_free()
	user_interface_node.visible = false
	Root_instance = load(scene_path).instantiate()
	Root.add_child.call_deferred(Root_instance)
