extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    var c=load("res://Chunk.gd").new(0,0)
    $Chunks.add_child(c)
    
func _input(event):
    pass
    
func get_blocks():
    var res=[]
    for c in $Chunks.get_children():
        for b in c.get_blocks():
            res.append(b)
    return res

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_just_pressed("ui_cancel"):
        get_tree().change_scene("res://MainMenu.tscn")
#    pass
