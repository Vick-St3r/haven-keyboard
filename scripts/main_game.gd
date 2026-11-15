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
	targetTextDisplay.text = targetText


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_text_edit_text_changed() -> void:
	if textedit.text == "hi":
		print("poop")
