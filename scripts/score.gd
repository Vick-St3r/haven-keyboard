extends Node

@onready var reportcardpop = $reportcard
var grade
var wpm
var sec

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(reportcardpop, "position", Vector2(0,0), 1.2)
	
	var main_game_node = get_node("../MainGame") 
	if main_game_node:
		main_game_node.reportcard.connect(_on_main_game_reportcard)

func _on_main_game_reportcard(new_grade: String, new_wpm: float, new_sec: float) -> void: 
	grade = new_grade
	wpm = new_wpm
	sec = new_sec
	print("Received Grade: ", grade)
	print("Received WPM: ", wpm)
	print("Received Time: ", sec)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
