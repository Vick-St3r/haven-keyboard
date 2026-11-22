extends Node

@onready var reportcardpop = $reportcard

@onready var gradetext = $reportcard/grade
@onready var wpmtext = $reportcard/wpm
@onready var timetext = $reportcard/time
var grade: String
var wpm: float
var sec: float
var accuracy: float

@onready var wpmchar = $reportcard/wpmdesc/wpmchar
@onready var wpmfeed = $reportcard/wpmdesc/wpmfeed

@onready var timechar = $reportcard/timedesc/timechar
@onready var timefeed = $reportcard/timedesc/timefeed

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
	accuracy = Signalsender.final_accuracy
	
	print("Grade: ", grade)
	print("WPM: ", wpm)
	print("Time: ", sec)
	print("Accuracy: ", sec)
	
	gradetext.text = str(grade)
	wpmtext.text = str(int(wpm))
	timetext.text = str(int(sec))
	
	if wpm >= 80:
		wpmchar.text = "E"
		wpmfeed.text = "Your knowledge is evident and your speed is clear."
	elif wpm >= 70: 
		wpmchar.text = "G"
		wpmfeed.text = "You ask meaningful questions."
	elif wpm >= 60: 
		wpmchar.text = "S"
		wpmfeed.text = "You're encouraged to pay more attention in class."
	else:
		wpmchar.text = "N"
		wpmfeed.text = "You need to show up to class more."
	#--------------
	if sec >= Global.timeLimit*0.90:
		timechar.text = "N"
		timefeed.text = "You need to show up to class more."
	elif sec >= Global.timeLimit*0.80: 
		timechar.text = "S"
		timefeed.text = "You're encouraged to pay more attention in class."
	elif sec >= Global.timeLimit*0.70: 
		timechar.text = "G"
		timefeed.text = "You ask meaningful questions."
	else:
		timechar.text = "E"
		timefeed.text = "Your knowledge is evident and your speed is clear."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
