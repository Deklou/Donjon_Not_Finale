extends TextureProgressBar


func _ready():
	update_xp_progress(GameData.player_XP)

func update_xp_progress(current_xp: int):
	value = float(current_xp)
