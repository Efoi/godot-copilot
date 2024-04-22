@tool
extends TextEdit

signal EnterPressed

func _on_text_changed():
	if text.contains("\n"):
		emit_signal("EnterPressed")
