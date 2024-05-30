extends Node2D

var Root = null
var Root_instance = null
var user_interface_node = null

func _ready(): #premier appel du jeu, le joueur commence au niveau 0
	Root = get_tree().root
	Root_instance = preload("res://Menu/Command_Screen/Command_Screen.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	Root_instance.to_objectif_screen.connect(_to_stats_screen)
	GameState.restart_root.connect(_to_stats_screen) #si on recommence, on commence directement dans le niveau
	
func _to_objective_screen():
	Root_instance = preload("res://Menu/Objectif_Screen/Objectif_Screen.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	Root_instance.to_stats_screen.connect(_to_stats_screen)
	
func _to_stats_screen():
	Root_instance = preload("res://Menu/stats_screen.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	Root_instance.to_intro_level.connect(_to_intro_level)
	EntitiesState.Root = get_tree().root
	EntitiesState.Root.get_node("Root").add_child(preload("res://UI/user_interface.tscn").instantiate())
	for child in EntitiesState.Root.get_node("Root").get_children(): #je fais ça car il arrive que l'interface change de nom dans l'arbre...
		user_interface_node = child
	user_interface_node.visible = true
	
func _to_intro_level():
	EntitiesState.player_is_frozen = true
	if GameState.ending_triggered == true:
		GameState.reload_game()
	Root = get_tree().root
	Root_instance = preload("res://Levels/Demo/Tutorial.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	Root_instance.get_node("loading_zones").to_first_floor.connect(_to_first_floor)
	if user_interface_node != null:
		user_interface_node.visible = true
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	EntitiesState.player_is_frozen = false
	
func _to_first_floor():
	EntitiesState.player_is_frozen = true
	if EntitiesState.player_parent_node != null:
		Root = get_tree().root
		Root.remove_child.call_deferred(EntitiesState.player_parent_node)
		EntitiesState.player_parent_node.queue_free()
	EntitiesState.enemy_triggered_list.clear() 
	EntitiesState.enemy_turn_ended_list.clear()
	#faudra faire une fonction qui le fait tout seul
	if user_interface_node != null:
		user_interface_node.visible = false
	#faire une fonction transition de niveau (donc formaliser la transition
	var lvl_2 = preload("res://Transition/intro_to_first_floor.tscn").instantiate()
	Root.add_child.call_deferred(lvl_2)
	if is_inside_tree():
		await get_tree().create_timer(4.0).timeout
	lvl_2.queue_free()
	if user_interface_node != null:
		user_interface_node.visible = true
	Root = get_tree().root
	Root_instance = preload("res://Levels/Demo/First_Floor.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	GameState.to_stats_screen.connect(_to_the_end)
	Root_instance.get_node("loading_zones").to_secret_exit.connect(_to_secret)
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	EntitiesState.player_is_frozen = false
	
func _to_the_end():
	if EntitiesState.player_parent_node != null:
		Root = get_tree().root
		Root.remove_child.call_deferred(EntitiesState.player_parent_node)
		EntitiesState.player_parent_node.queue_free()
	GameState.ending_triggered = true
	EntitiesState.Root = get_tree().root
	for child in EntitiesState.Root.get_node("Root").get_children(): #je fais ça car il arrive que l'interface change de nom dans l'arbre...
		EntitiesState.Root.get_node("Root").remove_child.call_deferred(child)
		child.queue_free()
	_to_stats_screen()
	
func _to_secret():
	if EntitiesState.player_parent_node != null:
		Root = get_tree().root
		Root.remove_child.call_deferred(EntitiesState.player_parent_node)
		EntitiesState.player_parent_node.queue_free()
	Root = get_tree().root
	GameData.secret_triggered = true
	Root_instance = preload("res://Levels/Demo/secret.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	GameState.ending_triggered = true
	
'func _load_next_level(scene_path : String, signal_name : Signal):
	if EntitiesState.player_parent_node != null:
		Root = get_tree().root
		Root.remove_child.call_deferred(EntitiesState.player_parent_node)
		EntitiesState.player_parent_node.queue_free()
	user_interface_node.visible = false
	Root_instance = load(scene_path).instantiate()
	Root.add_child.call_deferred(Root_instance)'
	
