require 'opengl'
require 'scenetree.rb'

class Puyo3D < Node
  attr_reader :color, :id
  def initialize(id,color,row,column)
     super()
     @id=id
     @color=color
     @parent=nil
     set_position(column,-row,0.0)
  end
  def to_s
    v1=get_stage_position()
    v2=get_position()
    return super.to_s+" id: "+@id.to_s+" rel_row: "+(-v2.y).to_s+" rel_column: "+v2.x.to_s+" row: "+v1.y.to_s+" column: "+v1.x.to_s+" color: "+@color.to_s
  end
  def get_stage_position()
     v=@system_coord.get_row(3)
     v.x=v.x+2.5
     v.y=12.5-v.y
     v.z=0.0
     return v    
  end
  def draw()
    GL.PushMatrix()
    GL.MultMatrix(@transform.to_a)
    SimplePuyo3D.draw(@color)
    GL.PopMatrix()
  end
end

class SimplePuyo3D
  @@redpuyo=0
  @@greenpuyo=0
  @@bluepuyo=0
  @@yellowpuyo=0
  @@violetpuyo=0
  @@whitepuyo=0
  def SimplePuyo3D.init()
    @@redpuyo=GL.GenLists(6)
    genDisplayList(@@redpuyo,0)
    @@greenpuyo=@@redpuyo+1
    genDisplayList(@@greenpuyo,1)
    @@bluepuyo=@@redpuyo+2
    genDisplayList(@@bluepuyo,2)
    @@yellowpuyo=@@redpuyo+3
    genDisplayList(@@yellowpuyo,3)
    @@violetpuyo=@@redpuyo+4
    genDisplayList(@@violetpuyo,4)
    @@whitepuyo=@@redpuyo+5
    genDisplayList(@@whitepuyo,5)
  end
  def SimplePuyo3D.draw(color)
    if color==0 then GL.CallList(@@redpuyo) end
    if color==1 then GL.CallList(@@greenpuyo) end
    if color==2 then GL.CallList(@@bluepuyo) end
    if color==3 then GL.CallList(@@yellowpuyo) end
    if color==4 then GL.CallList(@@violetpuyo) end
    if color==5 then GL.CallList(@@whitepuyo) end
  end
  def SimplePuyo3D.genDisplayList(list,color)
    GL.NewList(list,GL::COMPILE)
      GL.Material(GL::FRONT, GL::SPECULAR, [1.0,1.0,1.0,1.0] )  
      GL.Material(GL::FRONT, GL::EMISSION, [0.0,0.0,0.0,1.0] )
      if color==0 then GL.Color(1.0,0.0,0.0,1.0) end
      if color==1 then GL.Color(0.0,1.0,0.0,1.0) end
      if color==2 then GL.Color(0.0,0.0,1.0,1.0) end
      if color==3 then GL.Color(1.0,1.0,0.0,1.0) end
      if color==4 then GL.Color(1.0,0.0,1.0,1.0) end  
      if color==5 then GL.Color(1.0,1.0,1.0,1.0) end    
      q=GLU.NewQuadric()
      GLU.Sphere(q,0.5,16,16)
      GLU.DeleteQuadric(q)
    GL.EndList()
  end
end