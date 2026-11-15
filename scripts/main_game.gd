extends Node

@onready var textedit = $TextEdit
var targetText;
@onready var targetTextDisplay = $texttype
@onready var timertext = $clock/time
const textFilesPath = "res://texts/"
@onready var textFiles = [
	textFilesPath + "mitosis.txt",
	textFilesPath + "mitochondria.txt",
	textFilesPath + "organism.txt",
	textFilesPath + "photosynthesis.txt",
]
var originalSentences;
var scrambledSentences;
var curSentence = 0;
var badSentenceDone = false;
var sec: float = 0.0
var timeLeft: float = 0.0;
var timeLimit = 0;
var originalText;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load contents of a random txt file
	randomize()
	originalText = FileAccess.get_file_as_string(textFiles.pick_random())
	originalSentences = originalText.split(".")
	scrambledSentences = originalSentences.duplicate()
	for i in scrambledSentences.size():
		scrambledSentences[i] = scrambleText(scrambledSentences[i])
	targetText = scrambledSentences[curSentence] + "."
	targetTextDisplay.push_color(Color.BLACK)
	targetTextDisplay.add_text(targetText)

	startTimer()
	
	textedit.position.x = targetTextDisplay.position.x;
	textedit.position.y = targetTextDisplay.position.y-2;
	textedit.size.x = targetTextDisplay.size.x;
	textedit.size.y = targetTextDisplay.size.y;

func scrambleText(text):
	var words = text.split(" ")
	for i in words.size() - 1:
		if randi_range(0, 9) == 0:
			words = swapAtIndex(words, i)
	return " ".join(words)
	

func swapAtIndex(arr, index):
	var temp = arr[index+1]
	arr[index+1] = arr[index]
	arr[index] = temp
	return arr;

func startTimer():
	timeLimit = originalText.split(" ").size() * 1.5;
	timeLeft = timeLimit;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sec +=delta
	timeLeft -= delta
	timertext.text = str(int(timeLeft))

func _on_text_edit_text_changed() -> void:
	if textedit.text == targetText:
		if !badSentenceDone:
			targetText = originalSentences[curSentence].strip_edges() + "."
			badSentenceDone = true
		else:
			curSentence += 1;
			targetText = scrambledSentences[curSentence].strip_edges() + "."
			textedit.clear()
			badSentenceDone = false
		targetTextDisplay.text = targetText
	updateTextDisplay()

func updateTextDisplay():
	targetTextDisplay.clear()
	if !badSentenceDone:
		# check if typed text matches
		for i in min(textedit.text.length(), targetText.length()):
			if textedit.text[i] == targetText[i]:
				targetTextDisplay.push_color(Color.GREEN)
			else:
				targetTextDisplay.push_color(Color.RED)
			targetTextDisplay.add_text(targetText[i])
			targetTextDisplay.pop_all()
			
		# fill in the remaining text
		targetTextDisplay.push_color(Color.BLACK)
		targetTextDisplay.add_text(targetText.substr(textedit.text.length()))
		targetTextDisplay.pop_all()
	else:
		# check if it matches word by word
		var targetWords = targetText.split(" ")
		var typedWords = textedit.text.split(" ")
		for i in typedWords.size():
			if i < targetWords.size() && typedWords[i] == targetWords[i]:
				targetTextDisplay.push_color(Color.GREEN)
			else:
				targetTextDisplay.push_color(Color.RED)
			targetTextDisplay.add_text(typedWords[i] + " ")
			targetTextDisplay.pop_all()

		
