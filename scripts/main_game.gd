extends Node

signal reportcard(grade: String, wpm: float, sec: float)

@onready var textedit = $TextEdit
@onready var targetText = "";
@onready var targetTextDisplay = $texttype
@onready var timertext = $clock/time
const textFilesPath = "res://texts/"
@onready var texts = [
	#"Mitosis is a part of the cell cycle in eukaryotic cells in which replicated chromosomes are separated into two new nuclei. Cell division by mitosis is an equational division which gives rise to genetically identical cells in which the total number of chromosomes is maintained.",
	"A mitochondrion is an organelle. found in the cells of most eukaryotes, such as animals, plants and fungi. Mitochondria have a double membrane structure and use aerobic respiration to generate adenosine triphosphate (ATP), which is used throughout the cell as a source of chemical energy. They were discovered by Albert von Kölliker in 1857 in the voluntary muscles of insects. The term mitochondrion, meaning \"a thread-like granule\", was coined by Carl Benda in 1898. The mitochondrion is popularly nicknamed the \"powerhouse of the cell\", a phrase popularized by Philip Siekevitz in a 1957 Scientific American article of the same name.",
	#"An organism is any living thing that functions as an individual. Such a definition raises more problems than it solves, not least because the concept of an individual is also difficult. Several criteria, few of which are widely accepted, have been proposed to define what constitutes an organism. Among the most common is that an organism has autonomous reproduction, growth, and metabolism. This would exclude viruses, even though they evolve like organisms.",
	#"Photosynthesis is a system of biological processes by which photopigment-bearing autotrophic organisms, such as most plants, algae and cyanobacteria, convert light energy--typically from sunlight--into the chemical energy necessary to fuel their metabolism. The term photosynthesis usually refers to oxygenic photosynthesis, a process that releases oxygen as a byproduct of water splitting. Photosynthetic organisms store the converted chemical energy within the bonds of intracellular organic compounds (complex compounds containing carbon), typically carbohydrates like sugars (mainly glucose, fructose and sucrose), starches, phytoglycogen and cellulose."
]
var originalSentences;
var scrambledSentences;
var curSentence = 0;
var badSentenceDone = false;
var sec: float = 0.0
var timeLeft: float = 0.0;
var timeLimit = 0;
var originalText;

var total_characters_typed: int = 0
var previous_length: int = 0
var wpm: int = 0
var characters_already_typed = 0;
var minutes: float = 0.0

@onready var wpmnote = $stickynote/wpm
@onready var grade = $grade/actualgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load a random one of the paragraphs
	randomize()
	originalText = texts.pick_random()
	originalSentences = originalText.split(".", false)
	scrambledSentences = originalSentences.duplicate()
	for i in scrambledSentences.size():
		scrambledSentences[i] = scrambleText(scrambledSentences[i])
	targetText = scrambledSentences[curSentence] + "."
	#targetTextDisplay.add_text(targetText)
	
	# initialize text preview
	textedit.set_text(targetText)

	startTimer()
	
	textedit.position.x = targetTextDisplay.position.x;
	textedit.position.y = targetTextDisplay.position.y;
	textedit.size.x = targetTextDisplay.size.x;
	textedit.size.y = targetTextDisplay.size.y;

func scrambleText(text):
	var words = text.split(" ", false)
	for i in words.size() - 1:
		if randi_range(0, 1) == 0:
			words = swapAtIndex(words, i)
	return " ".join(words)
	

func swapAtIndex(arr, index):
	var temp = arr[index+1]
	arr[index+1] = arr[index]
	arr[index] = temp
	return arr;

func startTimer():
	timeLimit = originalText.split(" ", false).size() * 1.5;
	timeLeft = timeLimit;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sec +=delta
	timeLeft -= delta
	timertext.text = str(int(timeLeft))
	minutes = sec/60
	wpm = (total_characters_typed/5)/(minutes +0.000001)
	wpmnote.text = "WPM: \n" + str(wpm)
	
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

	if timeLeft <= 0:
		grade.text = "F";
		Signalsender.final_grade = grade.text
		Signalsender.final_wpm = wpm
		Signalsender.final_sec = sec
		get_tree().change_scene_to_file("res://scenes/score.tscn")

func _on_text_edit_text_changed() -> void:
	total_characters_typed = textedit.text.length() + characters_already_typed
		

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
	# end game once the player finishes the last sentence
	if curSentence >= originalSentences.size():
		Signalsender.final_grade = grade.text
		Signalsender.final_wpm = wpm
		Signalsender.final_sec = sec
		get_tree().change_scene_to_file("res://scenes/score.tscn")
	setTargetText(scrambledSentences[curSentence].strip_edges() + ".")
	characters_already_typed += textedit.text.length()
	textedit.clear()
	# update label to show new text
	#targetTextDisplay.text = targetText
	
	# initialize text preview
	textedit.set_text(targetText)



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
