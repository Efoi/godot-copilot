@tool
extends Control
var aichat
var aichatwindow: RichTextLabel 
var codeStyleBoxOverride: Theme
var questionStyleBoxOverride: Theme

func _ready():
	aichat = get_node("AIChat")
	aichat.connect("chat_received",_on_chat_received)
	var new_stylebox_normal: Theme = ResourceLoader.load("res://addons/copilot/code_block_style.tres")
	codeStyleBoxOverride = new_stylebox_normal
	var new_stylebox_question: Theme = ResourceLoader.load("res://addons/copilot/question-block-style.tres")
	questionStyleBoxOverride = new_stylebox_question
	#$MyButton.add_theme_stylebox_override("normal", new_stylebox_normal)
	# Remove the stylebox override.
	#$MyButton.remove_theme_stylebox_override("normal")

	pass

func remove_leading_spaces_or_newlines(text: String) -> String:
	return text.trim_prefix(" ").trim_prefix("\n")

func HandleChat():
	var input_value = %TextEdit.text.to_lower()
	%TextEdit.text = ""
	%TextEdit.placeholder_text="Waiting for results..."
	aichat.model = "codellama:7b"
	add_question_segment(input_value)
	#aichat.model = "starcoder2:15b"
	#aichat.model = "codeqwen"
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
	print(str)
	var text = remove_leading_spaces_or_newlines(str)
	print(text)
	if len(text)<2:
		print("TEXT REMOVED DUE TO SIZE")
		return
	print("Adding text segment")
	var rtl = RichTextLabel.new()
	rtl.text = text
	rtl.fit_content=true
	rtl.selection_enabled=true
	%chatcontainer.add_child(rtl)
	# Add regular text segment to RichTextLabel

func add_code_segment(str: String):
	print("Adding code segment")
	var code = remove_leading_spaces_or_newlines(str)
	if len(code)<1:
		print("CODE REMOVED DUE TO SIZE")
		return
	# Add code snippet to RichTextLabel with syntax highlighting
	code = code.replace("    ", "\t")
	#%AiChatWindow.text +="\n"  # Add a new line before the code block
	var rtl = RichTextLabel.new()
	rtl.text = code
	rtl.fit_content=true
	rtl.selection_enabled=true
	%chatcontainer.add_child(rtl)
	rtl.theme = codeStyleBoxOverride
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

