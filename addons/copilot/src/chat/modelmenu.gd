@tool
extends HBoxContainer

var models: Array
var config: config_handler
var modelsubmenu = load("res://addons/copilot/src/modelsubmenu.tscn")
var model_setting_menues : Array
var msubmenu
func _ready():
	config = config_handler.get_singleton()
	populate_models()
	msubmenu = modelsubmenu.instantiate()
	get_node("modelsubmenues").add_child(msubmenu)
	msubmenu.models_updated.connect(populate_models)


func populate_models():
	config = config_handler.get_singleton()
	var _models = config.ai_model_getall()
	if ! _models:
		print("You have no models.")
		return
	models = []
	for x in %modelList.get_children():
		%modelList.remove_child(x)
		x.queue_free()
	
	for i:AIModel in _models:
		models.append(i)
		var btn: Button = Button.new()
		btn.text = i.reference_name
		print("Model reference name"+i.reference_name)
		%modelList.add_child(btn)
		btn.pressed.connect(populate_sub_menu.bind(i))

func populate_sub_menu(i: AIModel):
	msubmenu.populateFields(i)

func _on_create_new_pressed():
	msubmenu.create_new_model()
	pass # Replace with function body.
