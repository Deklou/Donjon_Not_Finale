extends Node2D

var first_fall : bool = true
var inventory_acquired : bool = false
var shortcut_opened : bool = false
var one_enemy_left : bool = false
var no_enemy_left : bool = false
@onready var gardien_en_chef : CharacterBody2D = $"../Enemies/dummy_9"
@onready var coffre_liberation : RigidBody2D = $"../Chests/Chest15"
@onready var shortcut_scene : Node2D = $"../Tutorial_Shortcut"
#var shortcut_scene_demo_tilemap = shortcut_scene.get_node("Demo_TileMap")
#var shortcut_scene_animation_player = shortcut_scene.get_node("ColorRect_Animation/AnimationPlayer_Fade")

func _ready():
	GameState.tutorial_start.emit() #vers user_interface
	StatsSystem.update_player_stats.connect(_all_enemies_are_defeated) #pas propre mais meilleur solution que j'ai trouvé pour savoir quand tous les ennemis sont morts :/
	EntitiesState.disable_player_camera.emit() #vers script joueur

func _on_fall_area_2d_body_entered(body):
	if body is CharacterBody2D:
		for i in range (1,(2016 - body.global_position.y)/64):
			body.global_position = body.global_position + Vector2(0,64)
			await get_tree().create_timer(0.08-0.01*i).timeout
	if first_fall == true:
		GameData.player_HP_buffer = int(GameData.player_HP/5.0)
		EntitiesState.take_damage.emit("Player") #Envoi vers script joueur
		first_fall = false
		
func _on_inventory_log_area_2d_body_entered(_body):
	if inventory_acquired == false:
		Logs._add_log("Vous avez trouvé un\nbaluchon. Vous avez du\nmal à en distinguer\nle fond.")
		inventory_acquired = true
		
func _on_ui_hide_enemy_hp_area_2d_body_entered(_body):
	EntitiesState.hide_enemy_hp_stat_UI.emit() #vers user_interface
func _on_ui_hide_enemy_hp_area_2d_body_exited(_body):
	EntitiesState.show_enemy_hp_stat_UI.emit() #vers user_interface

func _on_ui_show_str_area_2d_body_entered(_body):
	EntitiesState.show_str_stat_UI.emit() #vers user_interface

func _on_ui_show_def_area_2d_body_entered(_body):
	EntitiesState.show_def_stat_UI.emit() #vers user_interface

func _on_silent_presence_log_area_2d_body_entered(_body):
	if GameState.silent_presence_log == false:
		Logs._add_log("Vous sentez une\nprésence silencieuse.")
		GameState.silent_presence_log = true
		GameState.intro_level_closed_door.emit() #vers Closed Door
		gardien_en_chef.global_position = Vector2(3616, 2080)
		coffre_liberation.global_position = Vector2(3424, 2080)
		
func _all_enemies_are_defeated():
	if EntitiesState.player_parent_node != null and is_inside_tree():
		if EntitiesState.player_parent_node.get_node("Enemies").get_child_count() == 1 and one_enemy_left == false:
			one_enemy_left = true
			await get_tree().create_timer(3.0).timeout
			Logs._add_log("Un étrange silence\ns'intalle.")
			return
		if EntitiesState.player_parent_node.get_node("Enemies").get_child_count() == 0 and no_enemy_left == false:
			no_enemy_left = true
			await get_tree().create_timer(3.0).timeout
			Logs._add_log("J'ai prévu que\nquelqu'un allait\nvouloir s'infliger ça T_T")
			return

func _on_tutorial_end_area_2d_body_entered(_body):
	GameState.tutorial_end.emit() #vers user_interface
	EntitiesState.enable_player_camera.emit() #vers script joueur

func _on_shortcut_area_2d_body_entered(_body):
	if shortcut_opened == false :
		#shortcut_scene_demo_tilemap.visible = false
		#shortcut_scene_animation_player.play("fade_out")
		EntitiesState.player_parent_node.remove_child(shortcut_scene)
		shortcut_opened = true
