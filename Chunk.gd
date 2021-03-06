tool
extends StaticBody

export(float) var BlockWidth=1.0/8
export(int) var Blocks=8192

var blocks = {}
var octrees=[]
var mat = load("res://mat1.tres")
#var oct = load("res://Octree.gd").new(Vector3(-Blocks/2,-Blocks/2,-Blocks/2),Vector3(Blocks,Blocks,Blocks))
var collisionShape=CollisionShape.new()
var meshInstance = MeshInstance.new()

#func _init(blocks):
#  Blocks=blocks
#  oct = preload("res://octree.gd").new(Vector3(-Blocks/2,-Blocks/2,-Blocks/2),Vector3(Blocks,Blocks,Blocks))  

func _init(x,z):
    for y in range(4):
        var o=load("res://Octree.gd").new(Vector3(x*16-8,y*16-8,z*16-8),Vector3(16,16,16))
        octrees.append(o)
    for dy in range(-8,8):
      for dx in range(-8,8):
        SetBlock(dx,1,dy,1)
    
func _ready():
  collisionShape.disabled=false
  add_child(collisionShape)
  add_child(meshInstance)

func get_blocks():
    var res=[]
    for o in octrees:
        for b in o.get_blocks():
            res.append(b)
    return res

func get_side(norm):
    if norm==Vector3(0,1,0):
        return 0
    if norm==Vector3(0,-1,0):
        return 1
    if norm==Vector3(0,0,-1):
        return 2
    if norm==Vector3(0,0,1):
        return 3
    if norm==Vector3(-1,0,0):
        return 4
    if norm==Vector3(1,0,0):
        return 5

func clicked_at(hit):
  var pos=hit.position
  var lpos=to_local(pos)

  var norm=hit.normal
  var center = lpos-norm*BlockWidth/2.0
  var bpos=Vector3(round(center.x),round(center.y),round(center.z))
  var bnum=Vector3(round(center.x*8),round(center.y*8),round(center.z*8))
  var side=get_side(norm)
  var v=0
  if hit.button==1:
     v=1
  if side==0:
    SetBlock(bnum.x,bnum.y+v,bnum.z,v)
  if side==1:
    SetBlock(bnum.x,bnum.y-v,bnum.z,v)
  if side==2:
    SetBlock(bnum.x,bnum.y,bnum.z-v,v)
  if side==3:
    SetBlock(bnum.x,bnum.y,bnum.z+v,v)
  if side==4:
    SetBlock(bnum.x-v,bnum.y,bnum.z,v)
  if side==5:
    SetBlock(bnum.x+v,bnum.y,bnum.z,v)

  #print("Global pos: "+str(pos))
  #print("Local pos: "+str(lpos))
  #print("Center pos: "+str(center))
  #print("Block pos: "+str(bpos))
  #print("Block num: "+str(bnum))
  #print("Button: "+str(hit.button))

  #BuildGeometry()
var threads=[]
func SetBlock(x,y,z,v):
  if x==-0:
    x=0
  if y==-0:
    y=0
  if z==-0:
    z=0
  print("Set block at "+str(x)+", "+str(y)+", "+str(z)+", ")
  #var t = Thread.new()
  #threads.append(t)
  #blocks[str(x)+","+str(y)+","+str(z)]=v
  for o in octrees:
    if o.is_in(Vector3(x,y,z)):
      o.set_block(Vector3(x,y,z),v)
  #t.start(self,"BuildGeometry")
  BuildGeometry(0)
  
func GetBlock(x,y,z):
  var res=0
  for oct in octrees:
    if oct.is_in(Vector3(x,y,z)):
      res= oct.get_block(Vector3(x,y,z))
  return res

    
func BuildGeometry(i):
  var verts=[]
  var cnt=8
  var w=BlockWidth # 1.0/cnt
  var w2=w/2.0
  var drawn=0
  
  var all=get_blocks()
  for block in all:
    #var block=all[i]
    var x=block.pos.x
    var y=block.pos.y
    var z=block.pos.z
    if true:    
        var b=block.value
        var btop=GetBlock(x,y+1,z)
        var bbot=GetBlock(x,y-1,z)
        var bfront=GetBlock(x,y,z-1)
        var bback=GetBlock(x,y,z+1)
        var bleft=GetBlock(x-1,y,z)
        var bright=GetBlock(x+1,y,z)
        if b>0:
            drawn+=1
        #top
        if b>0 and btop<1:  
          verts.append(Vector3( w*x-w2, y*w+w2, w*z-w2))
          verts.append(Vector3( w*x+w2, y*w+w2, w*z-w2))
          verts.append(Vector3( w*x-w2, y*w+w2, w*z+w2))
          
          verts.append(Vector3( w*x-w2, y*w+w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w+w2, w*z-w2))
          verts.append(Vector3( w*x+w2, y*w+w2, w*z+w2))
        #bottom
        if b>0 and bbot<1:
          verts.append(Vector3( w*x-w2, y*w-w2, w*z-w2))
          verts.append(Vector3( w*x-w2, y*w-w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w-w2, w*z-w2))
          
          verts.append(Vector3( w*x-w2, y*w-w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w-w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w-w2, w*z-w2))
          
        #front
        if b>0 and bfront<1:
          verts.append(Vector3( w*x-w2, y*w-w2, w*z-w2))
          verts.append(Vector3( w*x+w2, y*w-w2, w*z-w2))
          verts.append(Vector3( w*x-w2, y*w+w2, w*z-w2))

          verts.append(Vector3( w*x-w2, y*w+w2, w*z-w2))
          verts.append(Vector3( w*x+w2, y*w-w2, w*z-w2))
          verts.append(Vector3( w*x+w2, y*w+w2, w*z-w2))
        #back
        if b>0 and bback<1:
          verts.append(Vector3( w*x-w2, y*w-w2, w*z+w2))
          verts.append(Vector3( w*x-w2, y*w+w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w-w2, w*z+w2))

          verts.append(Vector3( w*x-w2, y*w+w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w+w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w-w2, w*z+w2))
        
        #left
        if b>0 and bleft<1:
          verts.append(Vector3( w*x-w2, y*w-w2, w*z-w2))
          verts.append(Vector3( w*x-w2, y*w+w2, w*z-w2))
          verts.append(Vector3( w*x-w2, y*w-w2, w*z+w2))

          verts.append(Vector3( w*x-w2, y*w-w2, w*z+w2))
          verts.append(Vector3( w*x-w2, y*w+w2, w*z-w2))
          verts.append(Vector3( w*x-w2, y*w+w2, w*z+w2))
        #right
        if b>0 and bright<1:
          verts.append(Vector3( w*x+w2, y*w-w2, w*z-w2))
          verts.append(Vector3( w*x+w2, y*w-w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w+w2, w*z-w2))

          verts.append(Vector3( w*x+w2, y*w-w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w+w2, w*z+w2))
          verts.append(Vector3( w*x+w2, y*w+w2, w*z-w2))
  var conc=ConcavePolygonShape.new()
  conc.set_faces(verts)
  
  collisionShape.shape=conc
  var st = SurfaceTool.new()
  st.begin(Mesh.PRIMITIVE_TRIANGLES)
  for vert in verts:
    st.add_vertex(vert)
  st.generate_normals()
  st.set_material(mat)        
  meshInstance.mesh=st.commit()
  print(str(drawn)+" blocks drawn")    
