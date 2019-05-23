extends KinematicBody

var pitch=0
var yaw=0
var sens=0.001

func _ready():
    $Camera/Crosshair.position.x=OS.window_size.x/2
    $Camera/Crosshair.position.y=OS.window_size.y/2
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
func _input(event):
    if event is InputEventMouseMotion:
        pitch -= event.relative.x*sens
        yaw += event.relative.y*sens
        
func _process(delta):
    if Input.is_action_just_pressed("ui_focus_next"):
        if Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else: 
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
    rotation.y = pitch
    rotation.x=yaw        
