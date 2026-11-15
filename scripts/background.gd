extends Node

@onready var mouse = $mouse

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.tween_interval(1.0)
	tween.tween_callback(func(): mouse.visible = false)
	tween.tween_interval(1.0)
	tween.tween_callback(func(): mouse.visible = true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
