require "scenetree.rb"
require 'opengl'

class GLlight < Node
  def initialize(num)
    super()
    @num=num
    turn_on()
  end
  def turn_on()
    case @num
      when 0
        GL.Enable(GL::LIGHT0)
      when 1
        GL.Enable(GL::LIGHT1)
      when 2
        GL.Enable(GL::LIGHT2)
      when 3
        GL.Enable(GL::LIGHT3)
      when 4
        GL.Enable(GL::LIGHT4)
      when 5
        GL.Enable(GL::LIGHT5)
      when 6
        GL.Enable(GL::LIGHT6)
      when 7
        GL.Enable(GL::LIGHT7)
   end
  end

  def turn_off()
    case @num
      when 0
        GL.Disable(GL::LIGHT0)
      when 1
        GL.Disable(GL::LIGHT1)
      when 2
        GL.Disable(GL::LIGHT2)
      when 3
        GL.Disable(GL::LIGHT3)
      when 4
        GL.Disable(GL::LIGHT4)
      when 5
        GL.Disable(GL::LIGHT5)
      when 6
        GL.Disable(GL::LIGHT6)
      when 7
        GL.Disable(GL::LIGHT7)
   end
  end

  def draw()
    super
    v=@system_coord.get_row(3)
    case @num
      when 0
        GL.Lightfv(GL::LIGHT0,GL::POSITION,[v.x,v.y,v.z,0.0])
      when 1
        GL.Lightfv(GL::LIGHT1,GL::POSITION,[v.x,v.y,v.z,0.0])
      when 2
        GL.Lightfv(GL::LIGHT2,GL::POSITION,[v.x,v.y,v.z,0.0])
      when 3
        GL.Lightfv(GL::LIGHT3,GL::POSITION,[v.x,v.y,v.z,0.0])
      when 4
        GL.Lightfv(GL::LIGHT4,GL::POSITION,[v.x,v.y,v.z,0.0])
      when 5
        GL.Lightfv(GL::LIGHT5,GL::POSITION,[v.x,v.y,v.z,0.0])
      when 6
        GL.Lightfv(GL::LIGHT6,GL::POSITION,[v.x,v.y,v.z,0.0])
      when 7
        GL.Lightfv(GL::LIGHT7,GL::POSITION,[v.x,v.y,v.z,0.0])
    end
  end

end
