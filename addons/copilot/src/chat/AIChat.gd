@tool
extends "res://addons/copilot/LLM.gd"

var url = "http://localhost:11434/v1/chat/completions"
var SYSTEM_TEMPLATE : String= """You are a brilliant coding assistant for the game-engine Godot. The version used is Godot 4.0
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
const MAX_LENGTH = 15000

class Message:
	var role: String
	var content: String
	
	func get_json():
		return {
			"role": role,
			"content": content
		}

const ROLES = {
	"SYSTEM": "system",
	"USER": "user",
	"ASSISTANT": "assistant"
}

func _get_models():
	return [
		"codellama:7b"
	]

func _set_model(model_name):
	model = "codellama:7b"

func _send_user_prompt(user_prompt, user_suffix):
	var messages = format_prompt(user_prompt)
	get_completion(messages, user_prompt)

func format_prompt(prompt):
	var messages = []
	var system_prompt = SYSTEM_TEMPLATE
	var combined_prompt = prompt
	var diff = combined_prompt.length() - MAX_LENGTH
	var user_prompt = prompt 
	
	var msg = Message.new()
	msg.role = ROLES.SYSTEM
	msg.content = system_prompt
	messages.append(msg.get_json())
	
	msg = Message.new()
	msg.role = ROLES.USER
	msg.content = user_prompt
	messages.append(msg.get_json())
	
	return messages

func get_completion(messages, prompt):
	var suffix = ""
	var body = {
		"model": model,
		"messages": messages,
		"temperature": 0.3,
		"max_tokens": 2500
	}
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer %s" % api_key
	]
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed",on_request_completed.bind(prompt, suffix, http_request))
	var json_body = JSON.stringify(body)
	print(json_body)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		emit_signal("completion_error", null)


func on_request_completed(result, response_code, headers, body, pre, post, http_request):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var json = test_json_conv.get_data()
	var response = json
	if !response.has("choices") :
		emit_signal("completion_error", response)
		return
	var completion = response.choices[0].message
	if is_instance_valid(http_request):
		http_request.queue_free()
	emit_signal("chat_received", completion.content, pre, post)
