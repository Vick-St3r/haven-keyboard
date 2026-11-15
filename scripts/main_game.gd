extends Node

@onready var textedit = $TextEdit
var targetText;
@onready var targetTextDisplay = $texttype
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load contents of a random txt file
	randomize()
	targetText = FileAccess.get_file_as_string(textFiles.pick_random())
	originalSentences = targetText.split(".")
	scrambledSentences = originalSentences.duplicate()
	for i in scrambledSentences.size():
		scrambledSentences[i] = scrambleText(scrambledSentences[i])
	targetText = scrambledSentences[curSentence] + "."
	targetTextDisplay.text = targetText

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_text_edit_text_changed() -> void:
	
	if textedit.text == targetText:
		if !badSentenceDone:
			targetText = originalSentences[curSentence] + "."
			badSentenceDone = true
		else:
			curSentence += 1;
			targetText = scrambledSentences[curSentence] + "."
			textedit.clear()
		targetTextDisplay.text = targetText
