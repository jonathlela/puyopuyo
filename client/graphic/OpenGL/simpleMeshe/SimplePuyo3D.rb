require 'opengl'

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
  
  def SimplePuyo3D.getMeshes(color)
    if color==0 then return @@redpuyo end
    if color==1 then return @@greenpuyo end
    if color==2 then return @@bluepuyo end
    if color==3 then return @@yellowpuyo end
    if color==4 then return @@violetpuyo end
    if color==5 then return @@whitepuyo end
  end
  
private

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
