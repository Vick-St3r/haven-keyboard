extends TextEdit

@onready var targetTextDisplay = $texttype
var total_characters_typed: int = 0
var previous_length: int = 0
var wpm: int = 0
var minutes: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_changed.connect(_on_text_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#minutes = MainGame.sec/60
	#wpm = (total_characters_typed/5)/minutes
	#print(wpm)

func _on_text_changed() -> void:
	var current_length = text.length()
	if current_length > previous_length:
		total_characters_typed += (current_length - previous_length)
		previous_length = current_length
