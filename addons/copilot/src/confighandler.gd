@tool
extends Node
class_name config_handler
static var _instance
@export var config_key = "F4fv2Jxpasp20VS5VSp2Yp2v9aNVJ21aRK"
@export var config_name = "user://copilot.cfg"
const ai_model_section_name = "aimodels"
var config: ConfigFile
const chatmodel_cfg_key_and_section = "aichatmodel"
const ccmodel_cfg_key_and_section = "aiccmodel"

func _init():
	if not _instance:
		_instance = self
		config = ConfigFile.new()
		var err = config.load_encrypted_pass(config_name, config_key)
	else:
		self.queue_free()

func ai_chat_model_get():
	var key = get_key(chatmodel_cfg_key_and_section,chatmodel_cfg_key_and_section)
	if key:
		return key
	return null

func ai_chat_model_save(id: int):
	save(chatmodel_cfg_key_and_section,chatmodel_cfg_key_and_section,id)
	return

func ai_cc_model_save(id: int):
	save(ccmodel_cfg_key_and_section,ccmodel_cfg_key_and_section,id)
	return

func ai_cc_model_get() -> int:
	return get_key(ccmodel_cfg_key_and_section,ccmodel_cfg_key_and_section)

func get_random_ai_identifier():
	var random_number: int = randi()%2147483647
	if config.has_section_key(ai_model_section_name,str(random_number)):
		return get_random_ai_identifier()
	return random_number

func ai_model_save(m: AIModel):
	if ! m.identifier:
		m.identifier = get_random_ai_identifier()
	save(ai_model_section_name,str(m.identifier),m)

func ai_model_load(identifier: int) -> AIModel:
	if config.has_section(ai_model_section_name):
		if config.has_section_key(ai_model_section_name,str(identifier)):
			return config.get_value(ai_model_section_name,str(identifier))
	return null

func ai_model_delete(m: AIModel):
	if config.has_section_key(ai_model_section_name,str(m.identifier)):
		config.erase_section_key(ai_model_section_name,str(m.identifier))
	config.save_encrypted_pass(config_name, config_key)

func ai_model_getall():
	print("Getting all AI models")
	if not config.has_section(ai_model_section_name):
		print("no section with models in settings file.")
		return null
	var model_array: Array = []
	for key in config.get_section_keys(ai_model_section_name):
		var aimodel: AIModel = config.get_value(ai_model_section_name,key)
		print("AI model identifier: "+key)
		print("AI model name: "+aimodel.model_name)
		model_array.append(aimodel)
	print(model_array)
	if len(model_array) > 0:
		return model_array
	return null

func save(section, key, value):
	print("Saving something")
	config.set_value(section, key, value)
	config.save_encrypted_pass(config_name, config_key)


func get_key(section: String, key: String):
	if config.has_section(section):
		return config.get_value(section, key)
	else:
		return null

func get_section_keys(section):
	if config.has_section(section):
		var section_keys = config.get_section_keys(section)
		print(section_keys)
		return section_keys
	return null


static func get_singleton():
	return _instance
