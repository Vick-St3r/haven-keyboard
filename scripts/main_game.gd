extends Node

signal reportcard(grade: String, wpm: float, sec: float, accuracy: float)

@onready var textedit = $TextEdit
var targetText = "";
@onready var targetTextDisplay = $texttype
@onready var timertext = $clock/time
@onready var animation_player: AnimationPlayer = $Shaders/AnimationPlayer
@onready var camera: Camera2D = $Camera2D

const textFilesResourcePath = "res://texts/"
const textFilesUserPath = "user://texts/"
var originalSentences;
var scrambledSentences;
var curSentence = 0;
var badSentenceDone = false;
var sec: float = 0.0
var timeLeft: float = 0.0;
var originalText;

var total_characters_typed: int = 0
var previous_length: int = 0
var wpm: int = 0
var characters_already_typed = 0;
var minutes: float = 0.0

@onready var wpmnote = $stickynote/wpm
@onready var accuracy_note = $stickynote/accuracy
@onready var grade = $grade/actualgrade
@onready var progress: Label = $stickynote/progress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#check if text files exist
	var textsCount = 0
	#for file in DirAccess.get_files_at(textFilesUserPath):
	for file in DirAccess.get_files_at(textFilesResourcePath):
		if file.get_extension() == "txt":
			textsCount += 1
			
	if not DirAccess.dir_exists_absolute(textFilesUserPath) or textsCount == 0:
		cloneTextResources()
		
	# load contents of a random txt file
	randomize()
	#var allUserFilesInTextsDir = DirAccess.get_files_at(textFilesUserPath)
	var allTextsInResourceDir = DirAccess.get_files_at(textFilesResourcePath)
	
	#only keep txt files
	var allTextFiles: Array[String] = [] 
	#for i in range(0, allUserFilesInTextsDir.size()):
		#if allUserFilesInTextsDir[i].get_extension() == "txt":
			#allTextFiles.append(allUserFilesInTextsDir[i])
	for i in range(0, allTextsInResourceDir.size()):
		if allTextsInResourceDir[i].get_extension() == "txt":
			allTextFiles.append(allTextsInResourceDir[i])
	
	#sets up text + scramble
	#var chosenFilePath = textFilesUserPath.path_join(allTextFiles.pick_random())
	var chosenFilePath = textFilesResourcePath.path_join(allTextFiles.pick_random())
	originalText = FileAccess.get_file_as_string(chosenFilePath)
	originalText = clean_string(originalText)
	originalSentences = originalText.split(".", false)
	scrambledSentences = originalSentences.duplicate()
	for i in scrambledSentences.size():
		scrambledSentences[i] = scrambleText(scrambledSentences[i])
	targetText = scrambledSentences[curSentence] + "."
	#targetTextDisplay.add_text(targetText)
	
	# initialize text preview
	textedit.set_text(targetText)

	startTimer()
	update_progress_label()
	
	textedit.position.x = targetTextDisplay.position.x;
	textedit.position.y = targetTextDisplay.position.y;
	textedit.size.x = targetTextDisplay.size.x;
	textedit.size.y = targetTextDisplay.size.y;

# removes any non-printable characters from a string
func clean_string(text):
	# remove any extra spaces around the string
	text = text.strip_edges()
	var new_string = ""
	for i in text.length():
		if text.unicode_at(i) >= 32 && text.unicode_at(i) <= 126:
			new_string += text[i]
	return new_string
	

func scrambleText(text):
	var words = text.split(" ", false)
	var num_swaps = roundi(words.size() / 10.0)
	var indices = range(0, words.size() - 1)
	indices.shuffle()
	var swap_indices = indices.slice(0, num_swaps)
	swap_indices.sort()
	print(swap_indices)
	for i in swap_indices:
		words = swapAtIndex(words, i)
	return " ".join(words)

func swapAtIndex(arr, index):
	var temp = arr[index+1]
	arr[index+1] = arr[index]
	arr[index] = temp
	return arr;

func startTimer():
	Global.timeLimit = originalText.split(" ", false).size() * 1.5;
	timeLeft = Global.timeLimit;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#time + wpm calculations
	sec += delta
	timeLeft -= delta
	timertext.text = str(int(timeLeft))
	minutes = sec/60
	wpm = (total_characters_typed/5)/(minutes +0.000001)
	wpmnote.text = "WPM: \n" + str(wpm)
	accuracy_note.text = "Accuracy: \n" + str(roundi(textedit.accuracy)) + "%"
	
	if wpm >= 80:
		grade.text = "A"
	elif wpm >= 70: 
		grade.text = "B"
	elif wpm >= 60: 
		grade.text = "C"
	elif wpm >= 50: 
		grade.text = "D"
	else:
		grade.text = "F"

	# player loses
	if timeLeft <= 0:
		grade.text = "F";
		Signalsender.final_grade = grade.text
		Signalsender.final_wpm = wpm
		Signalsender.final_sec = sec
		Signalsender.final_accuracy = textedit.accuracy
		get_tree().change_scene_to_file("res://scenes/score.tscn")

func _on_text_edit_text_changed() -> void:
	total_characters_typed = textedit.actual_text.length() + characters_already_typed

func on_round_completion():
	if !badSentenceDone:
		badSentenceDone = true
		setTargetText(originalSentences[curSentence].strip_edges() + ".")
		# hide original text while correcting words
		targetTextDisplay.clear()
		# handle case where there were no typos in original - immediately go to next sentence
		if textedit.text == targetText:
			goToNextSentence()
	else:
		goToNextSentence()

func setTargetText(newText):
	targetText = newText
	textedit.update_highlights()

func goToNextSentence():
	curSentence += 1;
	badSentenceDone = false
	# win condition
	# end game once the player finishes the last sentence
	if curSentence >= originalSentences.size():
		Signalsender.final_grade = grade.text
		Signalsender.final_wpm = wpm
		Signalsender.final_sec = sec
		Signalsender.final_accuracy = textedit.accuracy
		get_tree().change_scene_to_file("res://scenes/score.tscn")
	else:
		setTargetText(scrambledSentences[curSentence].strip_edges() + ".")
		
		# initialize text preview
		textedit.set_text(targetText)
		update_progress_label()
	
	camera.screen_shake(20, 0.2)
	animation_player.play("shockwave")
	animation_player.queue("RESET")

func update_progress_label():
	progress.text = str(curSentence+1) + "/" + str(originalSentences.size())

func cloneTextResources():
	print("cloning text files...")
	
	DirAccess.make_dir_recursive_absolute(textFilesUserPath)
	for file in DirAccess.get_files_at(textFilesResourcePath):
		var from = textFilesResourcePath.path_join(file)
		var to = textFilesUserPath.path_join(file)
		DirAccess.copy_absolute(from, to)


#func updateTextDisplay():
	#targetTextDisplay.clear()
	#if !badSentenceDone:
		## check if typed text matches
		#for i in min(textedit.text.length(), targetText.length()):
			#if textedit.text[i] == targetText[i]:
				#targetTextDisplay.push_bgcolor(Color.GREEN)
			#else:
				#targetTextDisplay.push_bgcolor(Color.RED)
			#targetTextDisplay.add_text(targetText[i])
			#targetTextDisplay.pop_all()
			#
		## fill in the remaining text
		#targetTextDisplay.push_color(Color.BLACK)
		#targetTextDisplay.add_text(targetText.substr(textedit.text.length()))
		#targetTextDisplay.pop_all()
	#else:
		## check if it matches word by word
		#var targetWords = targetText.split(" ")
		#var typedWords = textedit.text.split(" ")
		#for i in typedWords.size():
			#if i < targetWords.size() && typedWords[i] == targetWords[i]:
				#targetTextDisplay.push_bgcolor(Color.GREEN)
			#else:
				#targetTextDisplay.push_bgcolor(Color.RED)
			#targetTextDisplay.add_text(typedWords[i] + " ")
			#targetTextDisplay.pop_all()
