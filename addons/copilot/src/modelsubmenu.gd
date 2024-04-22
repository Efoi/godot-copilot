@tool
extends VBoxContainer

var curAIModel: AIModel
var config :config_handler
signal models_updated

func _init():
	config = config_handler.get_singleton()

func set_header_name(model_name: String):
	%HeaderLabel.text = "Settings for "+model_name

func populateFields(m : AIModel):
	curAIModel = m
	set_header_name(m.reference_name)
	%ReferenceName.text = m.reference_name
	%ModelName.text = m.model_name
	%ModelPrompt.text = m.prompt
	%ModelAPIKey.text = m.apiKey
	%ModelURL.text = m.url
	%code_completion.button_pressed = m.codecompletion
	%copilot.button_pressed = m.copilot
	pass

func create_new_model():
	if curAIModel:
		save()
	curAIModel = AIModel.new()
	set_header_name("NewModel")
	%ReferenceName.text = "NewModel"
	%ModelName.text = ""
	%ModelPrompt.text = ""
	%ModelAPIKey.text = ""
	%ModelURL.text = ""
	%code_completion.button_pressed = false
	%copilot.button_pressed = false
	pass

func save():
	if not curAIModel:
		curAIModel = AIModel.new()
	curAIModel.reference_name = %ReferenceName.text
	curAIModel.model_name = %ModelName.text
	curAIModel.prompt = %ModelPrompt.text
	curAIModel.apiKey = %ModelAPIKey.text
	curAIModel.url = %ModelURL.text
	curAIModel.codecompletion = %code_completion.button_pressed
	curAIModel.copilot = %copilot.button_pressed
	curAIModel.save()
	emit_signal("models_updated")


func _on_save_pressed():
	save()
	pass # Replace with function body.

func delete():
	config.ai_model_delete(curAIModel)
	emit_signal("models_updated")
	curAIModel = AIModel.new()
	%ReferenceName.text = "NewModel"
	%ModelName.text = ""
	%ModelPrompt.text = ""
	%ModelAPIKey.text = ""
	%ModelURL.text = ""
	%code_completion.button_pressed = false
	%copilot.button_pressed = false
	pass

func _on_delete_pressed():
	delete()
	pass # Replace with function body.


func _on_copy_pressed():
	var old_ai_model = curAIModel
	if curAIModel:
		save()
	curAIModel = AIModel.new()
	%ReferenceName.text = old_ai_model.reference_name
	%ModelName.text = old_ai_model.model_name
	%ModelPrompt.text = old_ai_model.prompt
	%ModelAPIKey.text = old_ai_model.apiKey
	%ModelURL.text = old_ai_model.url
	%code_completion.button_pressed = old_ai_model.codecompletion
	%copilot.button_pressed = old_ai_model.copilot
	save()
	pass # Replace with function body.


func _on_reference_name_text_changed(new_text):
	set_header_name(new_text)
	pass # Replace with function body.

func _on_copilot_toggled(toggled_on):
	curAIModel.copilot = toggled_on


func _on_code_completion_toggled(toggled_on):
	curAIModel.codecompletion = toggled_on
