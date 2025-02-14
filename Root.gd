extends Node2D
############### SCENES ##################
var transition_scene = preload("res://Transition/Fade_1.tscn")
var title_screen_scene = preload("res://Menu/Title_Screen/title_screen.tscn")
var option_scene = preload("res://Menu/Options_Screen/Options_Screen.tscn")
var objectif_scene = preload("res://Menu/Objectif_Screen/Objectif_Screen.tscn")
var command_scene = preload("res://Menu/Command_Screen/Command_Screen.tscn")
############### VARIABLES ##################
var transition_scene_animation_player: AnimationPlayer = null
var transition_instance = null
var root = null
var root_instance = null
var current_scene_instance
var user_interface_node = null

##################### READY #####################
func _ready(): #premier appel du jeu, c'est l'écran titre
	_to_start_screen()
##################### SCENES FONCTIONS #####################
func _to_start_screen():
	_add_scene_to_root(title_screen_scene)
	if not Signals.title_screen_to_options.is_connected(_to_options_screen):
		Signals.title_screen_to_options.connect(_to_options_screen)
	if not Signals.title_screen_to_new_game.is_connected(_to_objectif_screen):
		Signals.title_screen_to_new_game.connect(_to_objectif_screen)
func _to_options_screen():
	_add_scene_to_root(option_scene)
	if not Signals.options_back.is_connected(_to_start_screen):
		Signals.options_back.connect(_to_start_screen)
func _to_objectif_screen():
	_add_scene_to_root(objectif_scene)
	if not Signals.to_command_screen.is_connected(_to_command_screen):
		Signals.to_command_screen.connect(_to_command_screen)
func _to_command_screen():
	_add_scene_to_root(command_scene)
##################### SCENE GESTION #####################	
func _add_scene_to_root(scene: PackedScene) -> Node:
	root = get_tree().root
	root_instance = scene.instantiate()
	root.add_child.call_deferred(root_instance)
	return root_instance

	
func _to_objective_screen():
	if EntitiesState.player_parent_node == null: #si le joueur n'a pas été instancié
		root_instance = preload("res://Menu/Objectif_Screen/Objectif_Screen.tscn").instantiate()
		root.add_child.call_deferred(root_instance)
		root_instance.to_stats_screen.connect(_to_stats_screen)
	
func _to_stats_screen():
	root_instance = preload("res://Menu/Stats_Screen/stats_screen.tscn").instantiate()
	root.add_child.call_deferred(root_instance)
	root_instance.to_intro_level.connect(_to_intro_level)
	EntitiesState.Root = get_tree().root
	for child in EntitiesState.Root.get_node("Root").get_children(): #On vérifie que Root n'a pas déjà des enfants
		EntitiesState.Root.get_node("Root").remove_child(child)
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
	await get_tree().create_timer(4.0).timeout #pour que player_is_frozen reste bien à true pendant la transi 
	_unload_level("res://Levels/Demo/Tutorial.tscn")
	_load_next_level("res://Levels/Demo/First_Floor.tscn")
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	GameState.to_stats_screen.connect(_to_the_end)
	if EntitiesState.player_parent_node != null:
		EntitiesState.player_parent_node.get_node("loading_zones").to_secret_exit.connect(_to_secret)
		EntitiesState.player_parent_node.get_node("loading_zones").to_tutorial_from_first_floor.connect(_to_intro_level_from_first_floor)
	
func _to_intro_level_from_first_floor():
	_unload_level("res://Levels/Demo/First_Floor.tscn")
	_load_next_level("res://Levels/Demo/Tutorial.tscn")
	
func _to_the_end():
	if EntitiesState.player_parent_node != null:
		root = get_tree().root
		root.remove_child.call_deferred(EntitiesState.player_parent_node)
		EntitiesState.player_parent_node.queue_free()
	GameState.ending_triggered = true
	EntitiesState.Root = get_tree().root
	for child in EntitiesState.Root.get_node("Root").get_children(): #je fais ça car il arrive que l'interface change de nom dans l'arbre...
		EntitiesState.Root.get_node("Root").remove_child.call_deferred(child)
		child.queue_free()
	_to_stats_screen()
	
func _to_secret():
	if EntitiesState.player_parent_node != null:
		root = get_tree().root
		root.remove_child.call_deferred(EntitiesState.player_parent_node)
		EntitiesState.player_parent_node.queue_free()
	root = get_tree().root
	GameData.secret_triggered = true
	root_instance = preload("res://Levels/Demo/secret.tscn").instantiate()
	root.add_child.call_deferred(root_instance)
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
	root = get_tree().root
	var scene_name = _scene_path_to_scene_name(scene_path)
	if root.has_node(scene_name): #Si la hiérarchie possède la scène qu'on veut supprimer, on la supprime
		root.remove_child.call_deferred(root.get_node(scene_name))
	if EntitiesState.player_parent_node != null and EntitiesState.player_parent_node.has_node("Grid_player_2") == true: #Si on vient d'un niveau, on l'invisibilise et on supprime le joueur pour éviter les conflits entre les niveaux
		EntitiesState.player_parent_node.remove_child(EntitiesState.player_parent_node.get_node("Grid_player_2"))
		EntitiesState.enemy_triggered_list.clear()
		EntitiesState.enemy_turn_ended_list.clear()
	if user_interface_node != null: #S'il existe une instance de l'interface utilisateur, on la cache (pourquoi on la supprime pas ?)
		user_interface_node.visible = false
##################### DECHARGER PARENT JOUEUR #####################
func _unload_previous_level():
	EntitiesState.player_is_frozen = true
	root = get_tree().root
	var parent_path : String = EntitiesState.player_parent_node.get_path()
	if root.has_node(parent_path):
		var node_to_remove = root.get_node(parent_path)
		root.remove_child(node_to_remove)
		node_to_remove.queue_free()
	EntitiesState.enemy_triggered_list.clear()
	EntitiesState.enemy_turn_ended_list.clear()
##################### TRANSITION #####################
func _load_next_transition(transition_scene_path : String):
	EntitiesState.player_is_frozen = true
	var scene = ResourceLoader.load(transition_scene_path)
	if scene:
		var transition_scene = scene.instantiate()
		root.add_child.call_deferred(transition_scene)
		if is_inside_tree():
			await get_tree().create_timer(5.0).timeout
		transition_scene.queue_free()
##################### CHARGER NIVEAU #####################		
func _load_next_level(scene_path : String):
	root = get_tree().root
	var scene = ResourceLoader.load(scene_path)
	var scene_name = _scene_path_to_scene_name(scene_path)
	if root.has_node(scene_name): 
		if EntitiesState.player_parent_node == root.get_node(scene_name): #Si le niveau à charger et le niveau précédent sont les mêmes, on supprime la première instance
			root.remove_child.call_deferred(root.get_node(scene_name))
	else: #Si le niveau n'a pas encore été chargé une seule fois, on le charge
		if scene:
			var next_level_scene = scene.instantiate()
			root.add_child.call_deferred(next_level_scene)
	if user_interface_node != null:
		user_interface_node.visible = true
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	if EntitiesState.player_parent_node != null:
		EntitiesState.player_parent_node.add_child(preload("res://UI/Selector_UI.tscn").instantiate())
	EntitiesState.player_is_frozen = false
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
