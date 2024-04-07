extends Node2D

var Root = null
var Root_instance = null

#Ce script est ce qui appelé en premier par le jeu
#c'est le fil conducteur du jeu, il se charge de lancer chaque scène

func _ready(): #premier appel du jeu, le joueur commence au niveau 0
	$User_Interface.visible = false
	Root = get_tree().root
	Root_instance = preload("res://Menu/stats_screen.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	Root_instance.to_intro_level.connect(_to_intro_level)
	
func _to_intro_level():	
	if Root.has_node("stats_screen"):
		var lvl = Root.get_node("stats_screen")
		Root.remove_child.call_deferred(lvl)
		lvl.queue_free()
	$User_Interface.visible = true
	Root = get_tree().root
	Root_instance = preload("res://Levels/demo/intro_level.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	Root_instance.to_first_floor.connect(_to_first_floor)
	
	
func _to_first_floor():
	EntitiesState.enemy_triggered_list.clear()
	EntitiesState.enemy_turn_ended_list.clear()
	if Root.has_node("intro_level"):
		var lvl = Root.get_node("intro_level")
		Root.remove_child.call_deferred(lvl)
		lvl.queue_free()
	$User_Interface.visible = false
	var lvl_2 = preload("res://Transition/intro_to_first_floor.tscn").instantiate()
	Root.add_child.call_deferred(lvl_2)
	await get_tree().create_timer(4.0).timeout
	lvl_2.queue_free()
	$User_Interface.visible = true
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
	$User_Interface.visible = false
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
