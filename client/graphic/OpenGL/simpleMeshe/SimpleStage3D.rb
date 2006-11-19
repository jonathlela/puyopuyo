require 'opengl'

class SimpleStage3D
  @@stage=0
  
  def SimpleStage3D.init()
    @@stage=GL.GenLists(1)
    genDisplayList()
  end
  def SimpleStage3D.getMeshes()
    return @@stage
  end
private
  def SimpleStage3D.genDisplayList()
    GL.NewList(@@stage,GL::COMPILE)
#     turquoise background
      GL.Material(GL::FRONT, GL::SPECULAR, [1.0,1.0,1.0,1.0] ) ;
      GL.Material(GL::FRONT, GL::EMISSION, [0.0,0.0,0.0,1.0] ) ;
      GL.Color(0.0,1.0,1.0,1.0)
      GL.Begin(GL::QUADS)
        GL.Normal(-1,-1,1)   
        GL.Vertex(-5,-7.5,0);
        GL.Normal(1,-1,1) 
        GL.Vertex(5,-7.5,0);
        GL.Normal(1,1,1) 
        GL.Vertex(5,7.5,0);
        GL.Normal(-1,1,1) 
        GL.Vertex(-5,7.5,0);
      GL.End()
#     yellow border      
      GL.Material(GL::FRONT, GL::SPECULAR, [1.0,1.0,1.0,1.0] ) ;
      GL.Material(GL::FRONT, GL::EMISSION, [0.0,0.0,0.0,1.0] ) ;
      GL.Color(1.0,1.0,0.0,1.0)
      GL.Begin(GL::QUADS)     
#       quad1
        GL.Normal(-1,-0.85,1)    
        GL.Vertex(-4,-6,0.2);
        GL.Normal(-0.75,-0.85,1) 
        GL.Vertex(-3,-6,0.2);
        GL.Normal(-0.75,1,1) 
        GL.Vertex(-3,6,0.2);
        GL.Normal(-1,1,1)
        GL.Vertex(-4,6,0.2);
#       quad2    
        GL.Normal(-1,-1,1)  
        GL.Vertex(-4,-7,0.2);
        GL.Normal(-0.75,-1,1) 
        GL.Vertex(-3,-7,0.2);
        GL.Normal(-0.75,-0.85,1) 
        GL.Vertex(-3,-6,0.2);
        GL.Normal(-1,-0.85,1)
        GL.Vertex(-4,-6,0.2);
#       quad3       
        GL.Normal(1,-0.85,1)  
        GL.Vertex(4,-6,0.2);
        GL.Normal(0.75,-0.85,1) 
        GL.Vertex(3,-6,0.2);
        GL.Normal(0.75,1,1) 
        GL.Vertex(3,6,0.2);
        GL.Normal(1,1,1)
        GL.Vertex(4,6,0.2);
#       quad4    
        GL.Normal(1,-1,1)  
        GL.Vertex(4,-7,0.2);
        GL.Normal(0.75,-1,1) 
        GL.Vertex(3,-7,0.2);
        GL.Normal(0.75,-0.85,1) 
        GL.Vertex(3,-6,0.2);
        GL.Normal(1,-0.85,1)
        GL.Vertex(4,-6,0.2);
#       quad5    
        GL.Normal(-0.75,-1,1)  
        GL.Vertex(-3,-7,0.2);
        GL.Normal(0.75,-1,1) 
        GL.Vertex(3,-7,0.2);
        GL.Normal(0.75,-0.85,1) 
        GL.Vertex(3,-6,0.2);
        GL.Normal(-0.75,-0.85,1)
        GL.Vertex(-3,-6,0.2);
      GL.End()
    GL.EndList()
  end
end
