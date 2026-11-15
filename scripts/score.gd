extends Node

@onready var reportcard = $reportcard
var grade
var wpm
var sec

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(reportcard, "position", Vector2(0,0), 1.2)

func reportcard(grade: String, wpm: float, sec: float) -> void: 
	grade = grade
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
