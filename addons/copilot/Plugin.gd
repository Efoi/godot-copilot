@tool
extends EditorPlugin
	
	
const version = "1.0.0"
const scene_path = "res://addons/copilot/CopilotUI.tscn"
const chat_path = "res://addons/copilot/ChatWindow.tscn"
var dock
var chat_window
var editor_interface = get_editor_interface()

func _enter_tree() -> void:
	if(!dock):
		dock = load(scene_path).instantiate()
		add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, dock)
		main_screen_changed.connect(Callable(dock, "on_main_screen_changed"))
		dock.editor_interface = get_editor_interface()
		dock.set_version(version)
		
		chat_window = load(chat_path).instantiate()
		add_control_to_bottom_panel(chat_window,"AI Chat")

func _exit_tree():
	remove_control_from_docks(dock)
	remove_control_from_bottom_panel(chat_window)
	dock.queue_free()

