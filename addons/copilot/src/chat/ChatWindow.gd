@tool
extends Control
var aichat
var aichatwindow: RichTextLabel 
var codeStyleBoxOverride: Theme
var questionStyleBoxOverride: Theme
var scrollcontainer: ScrollContainer
var editor_interface : EditorInterface
var codeEditBox = preload("res://addons/copilot/lib/codeedit.gd")
var cfg: config_handler
var aimodel: AIModel

func _ready():
	cfg = config_handler.get_singleton()
	aichat = get_node("AIChat")
	aichat.connect("chat_received",_on_chat_received)
	set_chat_config()
	#aichat.model = "codellama:7b"
	#aichat.model = "starcoder2:15b"
	
	var new_stylebox_question: Theme = ResourceLoader.load("res://addons/copilot/resources/question-block-style.tres")
	questionStyleBoxOverride = new_stylebox_question
	#$MyButton.add_theme_stylebox_override("normal", new_stylebox_normal)
	# Remove the stylebox override.
	#$MyButton.remove_theme_stylebox_override("normal")
	pass

func set_chat_config():
	var all_models = cfg.ai_model_getall()
	var chatmodel_identifier = cfg.ai_chat_model_get()
	var aimodel = cfg.ai_model_load(chatmodel_identifier)
	aichat.model = aimodel.model_name
	aichat.SYSTEM_TEMPLATE=aimodel.prompt
	aichat.url = aimodel.url
	aichat.api_key = aimodel.apiKey
	
	

func remove_leading_spaces_or_newlines(text: String) -> String:
	return text.trim_prefix(" ").trim_prefix("\n")

func HandleChat():
	var input_value = %TextEdit.text
	%TextEdit.text = ""
	%TextEdit.placeholder_text="Waiting for results..."
	add_question_segment(input_value)
	set_chat_config()
	aichat.get_completion(aichat.format_prompt(input_value), input_value)


func _on_text_edit_enter_pressed():
	HandleChat()
	pass
	
func _on_chat_received(response: String, pre, post):
	parse_and_display_text(response)
	%TextEdit.placeholder_text="Enter your query... Click on Code Blocks to copy the content."


func parse_and_display_text(text):
	# Regular expression to match code blocks
	var code_regex = RegEx.new()
	code_regex.compile("`{3}(.*)")
	# Regular expression to match regular text segments
	var text_start = 0
	var code_found = false
	var code_match = code_regex.search(text)
	while code_match:
		code_found = !code_found
		var text_before = text.substr(text_start, code_match.get_start() - text_start)
		if code_found:
			add_text_segment(text_before)  # Add regular text segment
		if code_found == false:
			add_code_segment(text_before)  # Add code block
		text_start = code_match.get_start() + code_match.get_string(0).length()
		code_match = code_regex.search(text, text_start)

	# Add the remaining text after the last code block
	var remaining_text = text.substr(text_start)
	add_text_segment(remaining_text)

func add_question_segment(str: String):
	var question = remove_leading_spaces_or_newlines(str)
	if len(question)<2:
		return
	print("Adding question segment")
	var rtl: RichTextLabel = RichTextLabel.new()
	rtl.text = ">>> "+question
	rtl.fit_content=true
	rtl.selection_enabled=true
	rtl.theme = questionStyleBoxOverride
	%chatcontainer.add_child(rtl)
	# Add regular text segment to RichTextLabel

func add_text_segment(str : String):
	var text = remove_leading_spaces_or_newlines(str)
	if len(text)<2:
		return
	var rtl = RichTextLabel.new()
	rtl.text = text
	rtl.fit_content=true
	rtl.selection_enabled=true
	%chatcontainer.add_child(rtl)

func add_code_segment(str: String):
	var code = remove_leading_spaces_or_newlines(str)
	if len(code)<1:
		print("CODE REMOVED DUE TO SIZE")
		return
	# Add code snippet to RichTextLabel with syntax highlighting
	code = code.replace("    ", "\t") # In case the AI forgets that we use tabs.
	var rtl = codeEditBox.new()
	rtl.text = code
	%chatcontainer.add_child(rtl)
	
	rtl.gui_input.connect(copy_code_content.bind(rtl))
	# 
	#%AiChatWindow.text +="\n"   # Add a new line after the code block
	

func _on_clear_pressed():
	var nodes = %chatcontainer.get_children()
	for rtn in nodes:
		rtn.get_parent().remove_child(rtn)
		rtn.queue_free()

func copy_code_content(event, textnode):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			DisplayServer.clipboard_set(textnode.text)
			print(DisplayServer.clipboard_get())


func _on_save_btn_pressed():
	pass # Replace with function body.
