extends Node2D

#collison area
@onready var area2d = $Area2D
#sprite animation
@onready var button = $creditsbutton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connects functions
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	#change animation to hover button
	button.animation = "hover"

func _on_mouse_exited() -> void:
	#changes it back to the default button
	button.animation = "default"

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#changes scene when button is clicked
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			button.animation = "click"
			#get_tree().change_scene_to_file("")
			print("credits")
