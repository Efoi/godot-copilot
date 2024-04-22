@tool
extends HBoxContainer

var setting_submenues: Array
# Script for handling settings. 
# All settings should be visible once settings container is visible.
var cfg: config_handler

func _ready():
	cfg = config_handler.get_singleton()
	setting_submenues.append(%modelmenu)
	setting_submenues.append(%chatsettings)
	setting_submenues.append(%ccsettings)

func hideall():
	for m in setting_submenues:
		m.visible = false

func _on_model_settings_pressed():
	hideall()
	%modelmenu.visible = true

func _on_chat_settings_pressed():
	hideall()
	%chatsettings.visible = true
	%chatsettings.clear_model_menu()
	%chatsettings.populate_model_menu()

func _on_code_completion_pressed():
	hideall()
	%ccsettings.visible = true
	%ccsettings.clear_model_menu()
	%ccsettings.populate_model_menu()


func _on_load_defaults_pressed():
	var copilot = AIModel.new()
	copilot.reference_name = "Copilot"
	copilot.model_name="gpt-4"
	copilot.url="https://api.githubcopilot.com/chat/completions"
	copilot.prompt="""You are a brilliant coding assistant for the game-engine Godot. The version used is Godot 4.0, and all code must be valid GDScript!
That means the new GDScript 2.0 syntax is used. Here's a couple of important changes that were introduced:
- Use @export annotation for exports
- Use Node3D instead of Spatial, and position instead of translation
- Use randf_range and randi_range instead of rand_range
- Connect signals via node.SIGNAL_NAME.connect(Callable(TARGET_OBJECT, TARGET_FUNC))
- Same for sort_custom calls, pass a Callable(TARGET_OBJECT, TARGET_FUNC)
- Use rad_to_deg instead of rad2deg
- Use PackedByteArray instead of PoolByteArray
- Use instantiate instead of instance
- You can't use enumerate(OBJECT). Instead, use "for i in len(OBJECT):"

Remember, this is not Python. It's GDScript for use in Godot.
"""
	copilot.apiKey=""
	copilot.copilot=true
	copilot.codecompletion=true
	copilot.save()
	var openai3 = AIModel.new()
	openai3.reference_name = "OpenAI Davinci Chat"
	openai3.model_name="text-davinci-003"
	openai3.url="https://api.openai.com/v1/chat/completions"
	openai3.prompt="""#This is a GDScript script using Godot 4.0. 
#That means the new GDScript 2.0 syntax is used. Here's a couple of important changes that were introduced:
#- Use @export annotation for exports
#- Use Node3D instead of Spatial, and position instead of translation
#- Use randf_range and randi_range instead of rand_range
#- Connect signals via node.SIGNAL_NAME.connect(Callable(TARGET_OBJECT, TARGET_FUNC))
#- Connect signals via node.SIGNAL_NAME.connect(Callable(TARGET_OBJECT, TARGET_FUNC))
#- Use rad_to_deg instead of rad2deg
#- Use PackedByteArray instead of PoolByteArray
#- Use instantiate instead of instance
#- You can't use enumerate(OBJECT). Instead, use "for i in len(OBJECT):" 
#
#Remember, this is not Python. It's GDScript for use in Godot."""
	openai3.apiKey=""
	openai3.copilot=false
	openai3.codecompletion=false
	openai3.save()
	var openai4 = AIModel.new()
	openai4.reference_name = "OpenAICC-gpt3"
	openai4.model_name="gpt-3.5-turbo"
	openai4.url="https://api.openai.com/v1/chat/completions"
	openai4.prompt="""You are a brilliant coding assistant for the game-engine Godot. The version used is Godot 4.0, and all code must be valid GDScript!
That means the new GDScript 2.0 syntax is used. Here's a couple of important changes that were introduced:
- Use @export annotation for exports
- Use Node3D instead of Spatial, and position instead of translation
- Use randf_range and randi_range instead of rand_range
- Connect signals via node.SIGNAL_NAME.connect(Callable(TARGET_OBJECT, TARGET_FUNC))
- Same for sort_custom calls, pass a Callable(TARGET_OBJECT, TARGET_FUNC)
- Use rad_to_deg instead of rad2deg
- Use PackedByteArray instead of PoolByteArray
- Use instantiate instead of instance
- You can't use enumerate(OBJECT). Instead, use "for i in len(OBJECT):"

Remember, this is not Python. It's GDScript for use in Godot.
"""
	openai4.apiKey=""
	openai4.copilot=false
	openai4.codecompletion=true
	openai4.save()
	var openai5 = AIModel.new()
	openai5.reference_name = "OpenAICC-gpt4"
	openai5.model_name="gpt-4"
	openai5.url="https://api.openai.com/v1/chat/completions"
	openai5.prompt="""You are a brilliant coding assistant for the game-engine Godot. The version used is Godot 4.0, and all code must be valid GDScript!
That means the new GDScript 2.0 syntax is used. Here's a couple of important changes that were introduced:
- Use @export annotation for exports
- Use Node3D instead of Spatial, and position instead of translation
- Use randf_range and randi_range instead of rand_range
- Connect signals via node.SIGNAL_NAME.connect(Callable(TARGET_OBJECT, TARGET_FUNC))
- Same for sort_custom calls, pass a Callable(TARGET_OBJECT, TARGET_FUNC)
- Use rad_to_deg instead of rad2deg
- Use PackedByteArray instead of PoolByteArray
- Use instantiate instead of instance
- You can't use enumerate(OBJECT). Instead, use "for i in len(OBJECT):"

Remember, this is not Python. It's GDScript for use in Godot.
"""
	openai5.apiKey=""
	openai5.copilot=false
	openai5.codecompletion=true
	openai5.save()
	%modelmenu.populate_models()
	pass # Replace with function body.
