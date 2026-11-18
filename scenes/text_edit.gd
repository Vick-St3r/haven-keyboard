extends TextEdit
@onready var main_game: Node = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_changed.connect(_on_text_changed)
	syntax_highlighter = SpellingHighlighter.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_text_changed() -> void:
	pass

class SpellingHighlighter extends SyntaxHighlighter:
	func _get_line_syntax_highlighting(line: int) -> Dictionary:
		var color_map = {}
		var text_edit = get_text_edit()
		var user_text = get_text_edit().text
		var target_text = text_edit.main_game.targetText
		print(target_text)
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
	print("AAAAA")
