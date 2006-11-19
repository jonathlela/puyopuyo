require "scenetree.rb"
require 'opengl'
require 'math3d'
require 'client/graphic/interface/Light.rb'


class SimpleLight < Light

  @enabled = false



  def initialize(num)
    init()
    @num = num
  end
  
  def turn_on()
    GL.Enable(@num)
  end
  
  def turn_off()
    GL.Disable(@num)
  end  
  
  def draw()
    v=@system_coord.get_row(3)
    GL.Lightfv(@num,GL::POSITION,[v.x,v.y,v.z,0.0])
  end
  
  def apply_color()
    GL.Lightfv(@num,GL::AMBIENT,[0.0,0.0,0.0,1.0])
    GL.Lightfv(@num,GL::DIFFUSE,[@color[0],@color[1],@color[2],1.0])
    GL.Lightfv(@num,GL::SPECULAR,[0.1,0.1,0.1,1.0])
  end
  
end