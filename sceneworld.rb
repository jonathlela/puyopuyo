require 'opengl'
require 'scenetree'
require 'glcamera'

class World < Node
  def initialize(num)
    init()
    @nb=num
    @lights=Array.new(8,nil)
    @cameras=Array.new()
  end
  
  def render()
    if @cameras.empty? then raise "no camera" end
    
    light()
    
    GL.MatrixMode(GL::MODELVIEW)     
    GL.LoadIdentity()
    
    GL.Clear(GL::DEPTH_BUFFER_BIT)

    GL.MultMatrix(@cameras[0].get_system_coord_inverse)
    
    draw()
  end
  
  def init_view(x,y,width,height,fov,clipn,clipf)
    width=width/2
    case @nb
      when 0
        x=x
      when 1
        x=x+width
    end    
    GL.Viewport(x,y,width,height)
    GL.MatrixMode(GL::PROJECTION)
    GL.LoadIdentity()
    GLU.Perspective(fov,width/height,clipn,clipf)

  end
  
  def add_light(light)
    num=@lights.index(nil)
    if num==nil then raise "already 8 lights" end
    @lights[num]=light
  end
  
  def del_light(light)
    num=@lights.index(light)
    if num==nil then raise "not in list" end
    @lights[num]=nil
  end
  
  def add_camera(camera)
    if !@cameras.include?(camera) then
      @cameras.push(camera)
    else
      raise "already in list"
    end
  end

  def del_camera(camera)
    if !@cameras.include?(camera) then
      @cameras.delete(camera)
    else
      raise "not in list"
    end
  end

  def light()
    if @lighting==false then
      GL.Disable(GL::LIGHTING);
      GL.Disable(GL::COLOR_MATERIAL)
    else
      GL.Enable(GL::LIGHTING);
      GL.Enable(GL::COLOR_MATERIAL)
      GL.ColorMaterial(GL::FRONT, GL::AMBIENT_AND_DIFFUSE)  
    end   
  end
  
end
