extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
func _process(delta):
    if Input.is_action_just_pressed("ui_cancel"):
        get_tree().quit()

func _on_Button_pressed():
    get_tree().change_scene("res://World.tscn")


func _on_Button2_pressed():
    get_tree().quit()
