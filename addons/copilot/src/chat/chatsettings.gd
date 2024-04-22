@tool
extends HBoxContainer

var cfg: config_handler
var models: Array

func _ready():
	cfg = config_handler.get_singleton()
	populate_model_menu()
	pass

func populate_model_menu():
	models = cfg.ai_model_getall()
	for model:AIModel in models:
		print("Adding models to list: "+model.reference_name+" With identifier: "+str(model.identifier))
		%modelSelector.add_item(model.reference_name,model.identifier)
	var current_model = cfg.ai_chat_model_get()
	if current_model:
		%modelSelector.select(%modelSelector.get_item_index(current_model))
	pass

func clear_model_menu():
	%modelSelector.clear()

func _on_model_selector_item_selected(index):
	var item_selector = %modelSelector.get_selected_id()
	cfg.ai_chat_model_save(item_selector)
