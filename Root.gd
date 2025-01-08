extends Node2D

var Root = null
var Root_instance = null
var user_interface_node = null

func _ready(): #premier appel du jeu, le joueur commence au niveau 0
	Root = get_tree().root
	Root_instance = preload("res://Menu/Command_Screen/Command_Screen.tscn").instantiate()
	Root.add_child.call_deferred(Root_instance)
	GameState.to_game_from_menu.connect(_to_objective_screen)
	GameState.restart_root.connect(_to_stats_screen) #si on recommence, on commence directement dans le niveau
	
func _to_objective_screen():
	if EntitiesState.player_parent_node == null: #si le joueur n'a pas été instancié
		Root_instance = preload("res://Menu/Objectif_Screen/Objectif_Screen.tscn").instantiate()
		Root.add_child.call_deferred(Root_instance)
		Root_instance.to_stats_screen.connect(_to_stats_screen)
	
func _to_stats_screen():
	#if EntitiesState.player_parent_node == null: #si le joueur n'a pas été instancié
		Root_instance = preload("res://Menu/Stats_Screen/stats_screen.tscn").instantiate()
		Root.add_child.call_deferred(Root_instance)
		Root_instance.to_intro_level.connect(_to_intro_level)
		EntitiesState.Root = get_tree().root
		EntitiesState.Root.get_node("Root").add_child(preload("res://UI/user_interface.tscn").instantiate())
		for child in EntitiesState.Root.get_node("Root").get_children(): #je fais ça car il arrive que l'interface change de nom dans l'arbre...
			user_interface_node = child
		user_interface_node.visible = true
	
func _to_intro_level():
	_unload_level("res://Transition/intro_to_first_floor.tscn")
	_load_next_level("res://Levels/Demo/Tutorial.tscn")
	if is_inside_tree(): #Pour que le jeu ait le temps de détecter que le joueur a un parent
		await get_tree().create_timer(0.5).timeout
	if EntitiesState.player_parent_node != null:
		EntitiesState.player_parent_node.get_node("loading_zones").to_first_floor.connect(_to_first_floor)

func _to_first_floor():
	_load_next_transition("res://Transition/intro_to_first_floor.tscn")
	_unload_level("res://Levels/Demo/Tutorial.tscn")
	_load_next_level("res://Levels/Demo/First_Floor.tscn")
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	GameState.to_stats_screen.connect(_to_the_end)
	if EntitiesState.player_parent_node != null:
		EntitiesState.player_parent_node.get_node("loading_zones").to_secret_exit.connect(_to_secret)
		EntitiesState.player_parent_node.get_node("loading_zones").to_tutorial_from_first_floor.connect(_to_intro_level_from_first_floor)
	EntitiesState.player_is_frozen = false
	
func _to_intro_level_from_first_floor():
	_unload_level("res://Levels/Demo/First_Floor.tscn")
	_load_next_level("res://Levels/Demo/Tutorial.tscn")
	
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
##################### SCENE NOM #####################		
func _scene_path_to_scene_name(scene_path):
	var tscn_pos = scene_path.find(".tscn")
	if tscn_pos != -1:
		var left_part = scene_path.left(tscn_pos)
		var last_slash_pos = left_part.rfind("/")
		if last_slash_pos != -1:
			return left_part.right(scene_path.length() - last_slash_pos - 6) #On veut récupérer le nom de la scène pour la retrouver dans l'arbre	
##################### DECHARGER NIVEAU #####################	
func _unload_level(scene_path : String):
	EntitiesState.player_is_frozen = true
	Root = get_tree().root
	var scene_name = _scene_path_to_scene_name(scene_path)
	if Root.has_node(scene_name): #Si la hiérarchie possède la scène qu'on veut supprimer, on la supprime
		Root.remove_child.call_deferred(Root.get_node(scene_name))
	if EntitiesState.player_parent_node != null and EntitiesState.player_parent_node.has_node("Grid_player_2") == true: #Si on vient d'un niveau, on l'invisibilise et on supprime le joueur pour éviter les conflits entre les niveaux
		EntitiesState.player_parent_node.remove_child(EntitiesState.player_parent_node.get_node("Grid_player_2"))
		EntitiesState.enemy_triggered_list.clear()
		EntitiesState.enemy_turn_ended_list.clear()
	if user_interface_node != null: #S'il existe une instance de l'interface utilisateur, on la cache (pourquoi on la supprime pas ?)
		user_interface_node.visible = false
##################### DECHARGER PARENT JOUEUR #####################
func _unload_previous_level():
	EntitiesState.player_is_frozen = true
	Root = get_tree().root
	var parent_path : String = EntitiesState.player_parent_node.get_path()
	if Root.has_node(parent_path):
		Root.remove_child.call_deferred(Root.get_node(parent_path))
	EntitiesState.enemy_triggered_list.clear()
	EntitiesState.enemy_turn_ended_list.clear()
##################### TRANSITION #####################
func _load_next_transition(transition_scene_path : String):
	var scene = ResourceLoader.load(transition_scene_path)
	if scene:
		var transition_scene = scene.instantiate()
		Root.add_child.call_deferred(transition_scene)
		if is_inside_tree():
			await get_tree().create_timer(5.0).timeout
		transition_scene.queue_free()
##################### CHARGER NIVEAU #####################		
func _load_next_level(scene_path : String):
	EntitiesState.player_is_frozen = true
	Root = get_tree().root
	var scene = ResourceLoader.load(scene_path)
	var scene_name = _scene_path_to_scene_name(scene_path)
	if Root.has_node(scene_name): 
		if EntitiesState.player_parent_node == Root.get_node(scene_name): #Si le niveau à charger et le niveau précédent sont les mêmes, on supprime la première instance
			Root.remove_child.call_deferred(Root.get_node(scene_name))
	else: #Si le niveau n'a pas encore été chargé une seule fois, on le charge
		if scene:
			var next_level_scene = scene.instantiate()
			Root.add_child.call_deferred(next_level_scene)
	if user_interface_node != null:
		user_interface_node.visible = true
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	EntitiesState.player_is_frozen = false
	if EntitiesState.player_parent_node != null:
		EntitiesState.player_parent_node.add_child(preload("res://UI/Selector_UI.tscn").instantiate())	
##################### DEBUG #####################			
var debug1_pressed = false
var debug2_pressed = false
func _input(event):
	if GameState.debug_enabled == true:
		if event.is_action("debug1") or event.is_action("debug2"):	
			if event.is_action_pressed("debug1"):
				debug1_pressed = event.is_pressed()
			elif event.is_action_released("debug1"):
				debug1_pressed = event.is_pressed()
			if event.is_action_pressed("debug2"):
				debug2_pressed = event.is_pressed()
			elif event.is_action_released("debug2"):
				debug1_pressed = event.is_pressed()
func _process(_delta):
	if debug1_pressed and debug2_pressed:
		_unload_previous_level()
		_load_next_level("res://Levels/Debug/debug_level.tscn")
