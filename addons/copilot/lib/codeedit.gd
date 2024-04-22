extends CodeEdit

const colorComment: Color = Color(.8,.8,.8)
const colorKeyword: Color = Color(1,.6,.6)
const colorString: Color = Color(.9,.9,0)

func _ready():
	syntax_highlighter = highlight2()
	syntax_highlighter.number_color = Color(1,1,1)
	syntax_highlighter.symbol_color = Color(.6,1,1)
	syntax_highlighter.member_variable_color = Color(.9,.9,.5)
	syntax_highlighter.function_color = Color(.8,.8,1)
	syntax_highlighter.add_color_region("#","",colorComment)
	syntax_highlighter.add_color_region('"','"',colorString, false)
	#rtl.fit_content=true
	scroll_fit_content_height=true
	theme = ResourceLoader.load("res://addons/copilot/resources/code_block_style.tres")
	#rtl.selection_enabled=true
	editable = false
	set_draw_line_numbers(true)
	pass

var keywords = ["elif","is","self","class","class_name", "extends", "func", "var", "return", "if", "else", "onready", "for", "while", "break", "continue", "print"]

func highlight2():
	var edStxHl:CodeHighlighter = CodeHighlighter.new()
	for i in range(0,len(keywords)-1):
		edStxHl.add_keyword_color(keywords[i], colorKeyword)
	return edStxHl
