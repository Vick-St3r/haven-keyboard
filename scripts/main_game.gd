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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load contents of a random txt file
	randomize()
	targetText = FileAccess.get_file_as_string(textFiles.pick_random())
	targetText = scrambleText(targetText)
	targetTextDisplay.text = targetText

func scrambleText(text):
	var words = text.split(" ")
	for i in words.size() - 1:
		if randi_range(0, 4) == 4:
			words = swapAtIndex(words, i)
	print(words)
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
	if textedit.text == "hi":
		print("poop")
