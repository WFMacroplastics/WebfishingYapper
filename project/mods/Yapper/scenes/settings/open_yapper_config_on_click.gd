extends GenericUIButton
const YapperConfig = preload("res://mods/Yapper/scenes/settings/options_menu.tscn")


func _on_quit_pressed():
	get_tree().root.add_child(YapperConfig.instance())