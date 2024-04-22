@tool
extends Node

func _ready():
	%chatscroll.visible = true
	%settingsscroll.visible = false
	pass

func on_settings_clicked():
	if ! %chatscroll.visible:
		on_settings_exit()
		return
	%chatscroll.visible = false
	%settingsscroll.visible = true

func on_settings_exit():
	save_settings()
	%settingsscroll.visible = false
	%chatscroll.visible = true
	
func save_settings():
	pass


func _on_save_btn_pressed():
	on_settings_clicked()
	pass # Replace with function body.
