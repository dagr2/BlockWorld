extends KinematicBody

var pitch=0
var yaw=0
var sens=0.001
var vel=Vector3(0,0,0)
var dir=Vector3(0,0,0)
var speed=1.0
var is_flying=true
var Jumppower=10
var is_grav=false
var Gravity=0
var world

func _ready():
    world=get_parent()
    $Camera/Crosshair.position.x=OS.window_size.x/2
    $Camera/Crosshair.position.y=OS.window_size.y/2
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
func _input(event):
    if event is InputEventMouseMotion:
        pitch -= event.relative.x*sens
        yaw += event.relative.y*sens
        
    if event is InputEventMouseButton and event.pressed and event.button_index == 1:
        if $Camera/RayCast.is_colliding():
            var res=get_clicked_block()
            var p3=res.Block
            var chunk = res.Chunk
            
            chunk.SetBlock(p3.x,p3.y,p3.z,0)
        
    if event is InputEventKey and event.scancode==KEY_B:
        print(get_parent().get_blocks())
        
func _process(delta):
    if $Camera/RayCast.is_colliding():
        var t=get_parent().get_node("Target")
        t.translation=$Camera/RayCast.get_collision_point()
        
    var walk=Vector3(0,0,0)
    var fly=Vector3(0,0,0)
            
    dir=Vector3(0,0,1).rotated(Vector3(1,0,0),0)
    dir=dir.rotated(Vector3(0,1,0),pitch)
            
    if Input.is_action_just_pressed("ui_focus_next"):
        if Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else: 
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
    if yaw < -PI/2:
        yaw=-PI/2
    if yaw > PI/2:
        yaw=PI/2
        
    rotation.y = pitch
    rotation.x=yaw        
    
    if Input.is_action_pressed("ui_up"):
        walk = speed*Vector3(dir.x,0,dir.z)*10
            
    if Input.is_action_pressed("ui_down"):
        walk = -speed*Vector3(dir.x,0,dir.z)*10
        
    if Input.is_action_pressed("ui_left"):
        pass
        
    if Input.is_action_pressed("ui_right"):
        pass
        
    if Input.is_action_pressed("ui_jump"):
        if !is_flying:
            if is_on_floor(): 
                vel=vel+Vector3(0,Jumppower,0)
        else:
            fly.y = 10;

    if Input.is_action_pressed("ui_sneak"):
        if is_flying:
            fly.y = -10    
    if not is_on_floor() and is_grav and not is_flying:
        vel=vel+Vector3(0,-Gravity,0)
    else:
        vel =vel#*0.8#-= dir*0.1
    move_and_slide(vel+walk+fly,Vector3(0,1,0))  
    
    get_parent().get_node("Label").text=str(translation)+",     \n"+str(pitch)+", "+str(yaw)
    
func get_clicked_block():
    var p=$Camera/RayCast.get_collision_point()
    var n=$Camera/RayCast.get_collision_normal()
    var p2=p-n/2
    var p3=Vector3(round(p2.x),round(p2.y),round(p2.z))
    var chunk = $Camera/RayCast.get_collider()    
    var res={}
    res.Chunk=chunk
    res.Block=p3
    return res