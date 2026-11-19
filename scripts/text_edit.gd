extends TextEdit
@onready var main_game: Node = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_changed.connect(_on_text_changed)
	syntax_highlighter = SpellingHighlighter.new()
	selecting_enabled = false
	grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

var prev_length = 0
var actual_text = ""

func _on_text_changed() -> void:
	if !main_game.badSentenceDone:
		process_input_A()
		print(actual_text)
	else:
		process_input_B()

func process_input_A():
	var cur_length = text.length()
	# checks if a character was added
	if cur_length >= prev_length:
		
		if text.length() <= main_game.targetText.length():
			
			# allow adding a character if the following conditions are met:
			# expected character is not a space
			# OR expected character is a space, player has typed everything before correctly, and player types a space
			if main_game.targetText[text.length()-1] != ' ' || (actual_text == main_game.targetText.substr(0, text.length()-1) && text[text.length()-1] == ' '):
				actual_text += text.substr(text.length() - (cur_length - prev_length))
				set_text(main_game.targetText.substr(0, text.length()))	
				set_caret_column(get_line(0).length())
			else:
				set_text(main_game.targetText.substr(0, text.length()-1))
				set_caret_column(get_line(0).length())
		else:
			set_text(main_game.targetText)
			set_caret_column(get_line(0).length())
	else:
		set_text(main_game.targetText.substr(0, text.length()))
		set_caret_column(get_line(0).length())
		actual_text = actual_text.substr(0, actual_text.length() - (prev_length - cur_length))
		
	prev_length = text.length()
	
	# update sentence if user types everything correctly
	if actual_text == main_game.targetText:
		actual_text = "" # reset for the next round
		prev_length = 0
		on_round_completion()
		
func process_input_B():
	# check if inputted text equals target text, ignoring any extra spaces
	var user_text_words = text.split(" ", false)
	var target_text_words = main_game.targetText.split(" ", false)
	if user_text_words == target_text_words:
		on_round_completion()

func on_round_completion():
	# update main game data first
	main_game.on_round_completion()
	if !main_game.badSentenceDone:
		selecting_enabled = false
	else:
		selecting_enabled = true
	print(selecting_enabled)

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

class WordsHighlighter extends SyntaxHighlighter:
	func _get_line_syntax_highlighting(line: int) -> Dictionary:
		var color_map = {}
		var text_edit = get_text_edit()
		var user_text = text_edit.text
		var target_text = text_edit.main_game.targetText
		
		var user_text_words = user_text.split(" ", false)
		var word_start_indices = text_edit.get_word_start_indices(user_text)
		var target_text_words = target_text.split(" ", false)
		
		for i in user_text_words.size():
			if i >= target_text_words.size():
				color_map[word_start_indices[i]] = { "color": Color.RED }
			elif user_text_words[i] == target_text_words[i]:
				color_map[word_start_indices[i]] = { "color": Color.GREEN }
			else:
				color_map[word_start_indices[i]] = { "color": Color.RED }
		
		return color_map

func get_word_start_indices(text):
	var indices = []
	for i in text.length():
		if text[i] != ' ' && (i == 0 || text[i-1] == ' '):
			indices.append(i)
	return indices

func update_highlights():
	if main_game.badSentenceDone:
		syntax_highlighter = WordsHighlighter.new()
	else:
		syntax_highlighter = SpellingHighlighter.new()



# controlling inputs

const blocked_actions = [
	"ui_paste",
	"ui_text_caret_left",
	"ui_text_caret_right",
	"ui_text_caret_up",
	"ui_text_caret_down",
	"ui_text_caret_word_left",
	"ui_text_caret_word_right",
	"ui_text_caret_line_start",
	"ui_text_caret_line_end",
	"ui_text_caret_page_up",
	"ui_text_caret_page_down",
	"ui_text_caret_document_start",
	"ui_text_caret_document_end"
]

func _gui_input(event: InputEvent) -> void:
	
	if !main_game.badSentenceDone:
		# block enter and tab keys
		if event is InputEventKey:
			if event.keycode == KEY_ENTER || event.keycode == KEY_KP_ENTER || event.keycode == KEY_TAB:
				accept_event()
		
		for i in blocked_actions:
			if event.is_action(i):
				accept_event()
	else:
		selecting_enabled = true
