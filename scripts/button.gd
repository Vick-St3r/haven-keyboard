extends Node2D

@onready var area2d = $Area2D
@onready var button = $buttonsprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)



func _on_mouse_entered() -> void:
	button.animation = "hover"

func _on_mouse_exited() -> void:
	button.animation = "default"


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			button.animation = "click"
			get_tree().change_scene_to_file("res://scenes/main_game.tscn")
			print("Area2D clicked!")
