@tool
extends Node
class_name AIModel

@export var identifier: int
@export var reference_name: String
@export var model_name:String
@export var url:String
@export var prompt:String
@export var apiKey: String
var copilot:bool = false
var codecompletion: bool = false
var cfg: config_handler

func _ready():
	cfg = config_handler.get_singleton()

func save():
	if ! cfg:
		cfg = config_handler.get_singleton()
	cfg.ai_model_save(self)

func get_aimodel() -> AIModel:
	var oldSelf: AIModel
	oldSelf = cfg.ai_model_load(identifier)
	if oldSelf == null: 
		return self
	if check_if_equal(oldSelf):
		return oldSelf
	else:
		return self

func check_if_equal(second: AIModel):
	return (self.model_name == second.model_name && 
	self.url == second.url && 
	self.prompt == second.prompt
	)
