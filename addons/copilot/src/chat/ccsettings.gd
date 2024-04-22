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
		%ccmodelSelector.add_item(model.reference_name,model.identifier)
	var current_model = cfg.ai_cc_model_get()
	if current_model:
		%ccmodelSelector.select(%ccmodelSelector.get_item_index(current_model))

func clear_model_menu():
	%ccmodelSelector.clear()

func _on_model_selector_item_selected(index):
	var item_selector = %ccmodelSelector.get_selected_id()
	print("AI model index: "+str(index)+" AI Model Identifier:"+str(item_selector))
	cfg.ai_cc_model_save(item_selector)
