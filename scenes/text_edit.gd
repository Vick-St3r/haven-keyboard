extends TextEdit
@onready var main_game: Node = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_changed.connect(_on_text_changed)
	syntax_highlighter = SpellingHighlighter.new()
	grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

var prev_length = 0
var actual_text = ""

func _on_text_changed() -> void:
	var cur_length = text.length()
	# checks if a character was added
	if cur_length > prev_length:
		actual_text += text[text.length()-1]
		if text.length() < main_game.targetText.length():
			set_text(main_game.targetText.substr(0, text.length()))
			set_caret_column(get_line(0).length())
		else:
			set_text(main_game.targetText)
			set_caret_column(get_line(0).length())
	else:
		actual_text = actual_text.substr(0, actual_text.length() - (prev_length - cur_length))
	prev_length = cur_length
	print(actual_text)
	


class SpellingHighlighter extends SyntaxHighlighter:
	func _get_line_syntax_highlighting(line: int) -> Dictionary:
		var color_map = {}
		var text_edit = get_text_edit()
		var user_text = text_edit.actual_text
		var target_text = text_edit.main_game.targetText
		for i in user_text.length():
			if i >= target_text.length():
				color_map[i] = { "color": Color.RED }
			elif user_text[i] == target_text[i]:
				color_map[i] = { "color": Color.GREEN }
			else:
				color_map[i] = { "color": Color.RED }
			
		return color_map

func update_highlights():
	syntax_highlighter = SpellingHighlighter.new()
