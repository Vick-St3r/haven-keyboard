extends TextEdit

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
	pass
