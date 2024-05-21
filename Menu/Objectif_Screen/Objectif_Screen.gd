extends CanvasLayer

@onready var objectif_title_label : RichTextLabel = $Black_Background_ColorRect/Objectif/Objectif_Title
@onready var objectif_text_label : RichTextLabel = $Black_Background_ColorRect/Objectif/Objectif_Text
@onready var information_title_label : RichTextLabel = $Black_Background_ColorRect/Information/Information_Title
@onready var information_text_label : RichTextLabel = $Black_Background_ColorRect/Information/Information_Text
@onready var command_animation_player : AnimationPlayer = $ColorRect_Animation/AnimationPlayer_Fade
@onready var button_sprite_2d : Sprite2D = $Black_Background_ColorRect/Button/Button_Sprite_2D
@onready var button_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Button/Button_Green_Sprite_2D
var player_has_validated : bool = false

func _ready():
	command_animation_player.play("fade_in")
	objectif_title_label.bbcode_text = "[b][font_size=40]" + objectif_title_label.text + "[/font_size][/b]"
	objectif_text_label.bbcode_text = "[font_size=20]" + objectif_text_label.text + "[/font_size]"
	information_title_label.bbcode_text = "[b][font_size=40]" + information_title_label.text + "[/font_size][/b]"
	information_text_label.bbcode_text = "[font_size=20]" + information_text_label.text + "[/font_size]"

func _on_area_2d_mouse_entered():
	button_sprite_2d.visible = false
	button_green_sprite_2d.visible = not button_sprite_2d.visible

func _on_area_2d_mouse_exited():
	button_sprite_2d.visible = true

func _process(_delta):
	button_green_sprite_2d.visible = not button_sprite_2d.visible
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true and button_sprite_2d.visible == false and player_has_validated == false:
		player_has_validated = true
		var thumbs_up_scene = preload("res://Menu/Thumbs_Up/Thumbs_Up.tscn").instantiate()
		add_child.call_deferred(thumbs_up_scene)
		thumbs_up_scene.position = Vector2(832,624)
		button_sprite_2d.visible = true
		await get_tree().create_timer(0.1).timeout
		button_sprite_2d.visible = false
		await get_tree().create_timer(0.5).timeout
		command_animation_player.play("fade_out")
		await get_tree().create_timer(0.7).timeout
		queue_free()
