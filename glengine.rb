require 'sdl'
require 'opengl'
require 'timer'
require 'graphicengine'
require 'glplayer'
#require 'benchmark'
require 'framecontext'
require 'socket'
require 'graphicclient'
require "sdlcontrols.rb"
require "sdlcontrols2.rb"
require 'sceneworld'
require "client/graphic/OpenGL/SimpleLight/SimpleLight.rb"

class GLengine < GraphicEngine
  Width=800.0
  Height=600.0
  BPP=16
  FOV=45.0
  ClipNear=0.1
  ClipFar=20.0

  def initialize()
    initSDL()
    initOpenGL()
    init3D()
    initVar()
  
    control1 = SDLControls.new(SDL::Key::LEFT,SDL::Key::RIGHT,SDL::Key::DOWN,SDL::Key::B,SDL::Key::N)
    control2 = SDLControls.new(SDL::Key::Q,SDL::Key::D,SDL::Key::S,SDL::Key::A,SDL::Key::Z)
    control = SDLControls2.new(SDL::Key::L,SDL::Key::F)

    control1.player=@player[0]
    control2.player=@player[1]
    control.engine=self
    
    control1.listen
    control2.listen
    control.listen
    
    puts "ready"
    @client.listen()
    
    @framecontext.set_max_fps(100.0)
    @framecontext.limit()
    
    while true
      render()
    end
  end 

  def add_puyo_current(player,puyo3d)
    puts "add c 0"
    @player[player-1].add_puyo_current(puyo3d)
    puts "add c 1"
  end
#  def del_puyo_current(player,id)
#    puts "del c 0"
#    @player[player-1].del_puyo_current(id)
#    puts "del c 1"
#  end
#  def del_puyo_chart(player,id)
#    puts "del t 0"
#    @player[player-1].del_puyo_chart(id)
#    puts "del t 1"
#  end
#  def add_puyo_chart(player,puyo3d)
#    puts "add t 0"
#    @player[player-1].add_puyo_chart(puyo3d)
#    puts "add t 1"
#  end
  def move_puyo_from_current_to_chart(player,puyos_id)
    puts "move c t 0"
    @player[player-1].move_puyo_from_current_to_chart(puyos_id)
    puts "move c t 1"
  end
  def move_puyo_from_chart_to_current(player,puyos_id)
    puts "move t c 0"
    @player[player-1].move_puyo_from_chart_to_current(puyos_id)
    puts "move t c 1"
  end
  
  def explod(player,puyos_id,time_to_explod)
    puts "explod 0"
    @player[player-1].explod(puyos_id,time_to_explod)
    puts "explod 1"
  end  
  
  def down(player,time_to_fall_one_step)
    puts "d 0"
    @player[player-1].down(time_to_fall_one_step)
    puts "d 1"
  end
    

  
  def render()
      #t=Benchmark.realtime() {
      @framecontext.update()
      #@timer.frame()
      fps=@framecontext.fps
      #dt=@timer.get_deltaT()
      #time=@timer.get_time()
      SDL::WM.setCaption(sprintf("%05.1f fps",fps),"")
          
      @player.each { |player|
        player.update()
        player.animation()
        player.movement()
      }
      #}
      #puts "calcul: "+(t*1000).to_s+" ms"
      #t=Benchmark.realtime() {
      GL.ClearColor(0.0, 0.0, 0.0, 1.0)
      GL.Clear(GL::COLOR_BUFFER_BIT)
      
      @player.each { |player| 
        
        player.init_view(0.0,0.0,Width,Height,FOV,ClipNear,ClipFar)
        player.render()
      }
      @framecontext
      SDL.GLSwapBuffers()
      
      @framecontext.wait()
      #}
      #puts "draw: "+(t*1000).to_s+" ms"
  end
  
  def initSDL()
    SDL.init(SDL::INIT_VIDEO)
    SDL.setGLAttr(SDL::GL_RED_SIZE,5)
    SDL.setGLAttr(SDL::GL_GREEN_SIZE,5)
    SDL.setGLAttr(SDL::GL_BLUE_SIZE,5)
    SDL.setGLAttr(SDL::GL_DEPTH_SIZE,16)
    SDL.setGLAttr(SDL::GL_DOUBLEBUFFER,1)
    SDL.setVideoMode(Width,Height,BPP,SDL::OPENGL)  
    SDL.init(SDL::INIT_VIDEO)
    ObjectSpace.garbage_collect()
  end

  def initOpenGL()
    GL.Lightfv(GL::LIGHT0,GL::POSITION,[0.0,0.0,0.0,0.0])
    GL.Lightfv(GL::LIGHT0,GL::AMBIENT,[0.0,0.0,0.0,1.0])
    GL.Lightfv(GL::LIGHT0,GL::DIFFUSE,[1.0,1.0,1.0,1.0])
    GL.Lightfv(GL::LIGHT0,GL::SPECULAR,[0.1,0.1,0.1,1.0])
    GL.Lightfv(GL::LIGHT1,GL::POSITION,[0.0,0.0,0.0,0.0])
    GL.Lightfv(GL::LIGHT1,GL::AMBIENT,[0.0,0.0,0.0,1.0])
    GL.Lightfv(GL::LIGHT1,GL::DIFFUSE,[1.0,1.0,1.0,1.0])
    GL.Lightfv(GL::LIGHT1,GL::SPECULAR,[0.1,0.1,0.1,1.0])
    GL.LightModel(GL::LIGHT_MODEL_AMBIENT,[0.2,0.2,0.2,1])
    GL.Enable(GL::LIGHTING)
    GL.Enable(GL::COLOR_MATERIAL)
    GL.ColorMaterial(GL::FRONT,GL::AMBIENT_AND_DIFFUSE)  
    GL.Enable(GL::DEPTH_TEST)
    GL.DepthFunc(GL::LESS)
    GL.ShadeModel(GL::SMOOTH)
  end
  
  def init3D()
    SimplePuyo3D.init()
    SimpleStage3D.init()
  end
  
  def initVar()
    @framecontext=FrameContext.new
    @client=GraphicClient.new(self)
    @player=Array.new
    @player.push(GLplayer.new(0,0,@framecontext,@client))
    @player.push(GLplayer.new(1,0,@framecontext,@client))
    @limit=true
    
  end
  
  def move_left(player,puyos,time_to_fall_one_step)
     if player==@game.teams[0][0] then @player[0].move_left(puyos,time_to_fall_one_step) end
     if player==@game.teams[1][0] then @player[1].move_left(puyos,time_to_fall_one_step) end
  end
  
   def move_right(player,puyos,time_to_fall_one_step)
     if player==@game.teams[0][0] then @player[0].move_right(puyos,time_to_fall_one_step) end
     if player==@game.teams[1][0] then @player[1].move_right(puyos,time_to_fall_one_step) end
  end

  def lighting_pressed()
     @player.each { |player| player.change_lighting() } 
  end
  def frame_limit_pressed()
    if @limit then 
      @limit=false
      @framecontext.unlimit()
    else
      @limit=true
      @framecontext.limit()
    end   
  end

end

