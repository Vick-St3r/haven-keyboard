extends Node

@onready var reportcardpop = $reportcard
@onready var gradetext = $reportcard/grade
@onready var wpmtext = $reportcard/wpm
@onready var timetext = $reportcard/time
var grade: String
var wpm: float
var sec: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(reportcardpop, "position", Vector2(0,0), 1.2)
	
	# Grab the data straight from your Singleton autoload
	grade = Signalsender.final_grade
	wpm = Signalsender.final_wpm
	sec = Signalsender.final_sec
	
	print("Successfully Loaded Grade: ", grade)
	print("Successfully Loaded WPM: ", wpm)
	print("Successfully Loaded Time: ", sec)
	
	gradetext.text = str(grade)
	wpmtext.text = str(int(wpm))
	timetext.text = str(int(sec))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
