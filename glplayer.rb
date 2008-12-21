require 'glengine'
require 'client/graphic/Stage3D.rb'
require 'client/graphic/Puyo3D.rb'
require 'motion'
require 'puyo3dform'
require "sceneworld.rb"
require "currentpuyo.rb"
require "chartpuyo.rb"

class GLplayer < World
  WAIT=0
  FALL=1
  COLLISION=2
  FALL2=3
  EXPLODE=4
  DEBUG=true
  #DEBUG=false
  def initialize(team,num,framecontext,client)
    super(team)
    @team=team
    @num=num
    @lighting=true
    @framecontext=framecontext
    @client=client
    @stage=Stage3D.new
    @stat=WAIT
    @time=0
    @rleft=false
    @rright=false
    @left=false  
    @right=false
    @down=false
    @explode=0
    @dt=0
    @newframe=true
    @dt=0.0
    @time=0.0
    @framecount=0
    
    @zCamera=7.5*Math.cos((45.0/2)*(Math::PI/180))/Math.sin((45.0/2)*(Math::PI/180))
    
    @currentPuyo=CurrentPuyo.new
    @chartPuyo=ChartPuyo.new
    init_tree()
    
  end
  
  def init_tree()
    self.add_object(@stage)
    
    @camera=GLcamera.new
    @camera.set_position(0.0,0.0,@zCamera)
    self.add_camera(@camera)
    self.add_child(@camera)
    
    light=GLlight.new(0)
    light.set_position(5.0,5.0,10.0)
    self.add_child(light)
    self.add_light(light)
    
    table_node=Node.new()
    table_node.set_position(-2.5,12.5,0.0)
    self.add_child(table_node)
    
    table_node.add_child(@currentPuyo)
    table_node.add_child(@chartPuyo)
  end
  
  def update()
    @newframe=true
    @dt=@framecontext.dt
    @time=@framecontext.time
    @framecount=@framecontext.framecount
  end
  
  def explod(puyos_id,time_to_explod)
    
    move_puyo_from_chart_to_current(puyos_id)
    
    @stat=EXPLODE
    print_debug("explod")
    @explode=time_to_explod.to_f/1000
  end  
  
  def down(time_to_fall_one_step)
    if @currentPuyo.upstair?() then
      @stat=FALL
    else
      @stat=FALL2
    end
    print_debug("down")
    @currentPuyo.fall(@time,time_to_fall_one_step)
  end
  
  def collision()
    rl_collision=false
    ud_collision=false
    @currentPuyo.get_puyos().each { |puyo|
      v1=puyo.get_stage_position()
      if v1.x<0.0 || v1.x>5.0 then rl_collision=true end
      if v1.y>18.0 then ud_collision=true; return ud_collision,rl_collision end
      @chartPuyo.get_puyos().each  { |t_puyo|
        v2=t_puyo.get_stage_position()
        w=v1.x-v2.x
        h=v1.y-v2.y
        d=w*w+h*h
        if d<1.0 then
          #         if w<1.0 && w>-1.0 then rl_collision=true end
          #         if h<1.0 && h>-1.0 then ud_collision=true; return ud_collision,rl_collision end
          if w<1.0 && w>-1.0 && w!=0.0 then
            rl_collision=true
          else 
            if h<1.0 && h>-1.0 then
              ud_collision=true
              return ud_collision,rl_collision
            end
          end
        end
      }
    }
    return ud_collision,rl_collision
  end
  
  def animation()
    if @explode>0 then
      @explode-=@dt
      if @explode<=0 then 
        puts "dokkan"
        @explode=0
        print_debug("dokkan")
        @currentPuyo.clear()
        @client.explosion_completed(@team)
      end   
    end
  end
  
  def movement()
    
    if @stat==COLLISION || @stat==EXPLODE then return end
    
    @currentPuyo.background_movement(@time)
    
    if @stat==FALL then 
      @currentPuyo.interactive_movement(@time)
    end
    
    @currentPuyo.update()   
    
    ud_collision,rl_collision=collision()
    #puts "up_down: "+ud_collision.to_s+" left_right: "+rl_collision.to_s
    
    motion_name=@currentPuyo.get_background_motion()
    
    motion_name.each { |name| 
      case(name)
      when "fall"
        if ud_collision && @explode==0 then
          @currentPuyo.stop_background("fall")
          @currentPuyo.stop_all_interactive()
          @currentPuyo.round()
          @stat=COLLISION
          print_debug("collision")
          @client.updown_collision(@team,@currentPuyo.get_puyos())
        end
      end
    }
    
    if @stat==FALL then 
      
      motion_name=@currentPuyo.get_interactive_motion()
      
      motion_name.each { |name| 
        case(name)   
        when "down"
          if ud_collision && @explode==0 then
            @currentPuyo.stop_all_halted()
            @currentPuyo.stop_all_interactive()
            @currentPuyo.round()
            @stat=COLLISION
            print_debug("collision")
            @client.updown_collision(@team,@currentPuyo.get_puyos())
          else
            if @currentPuyo.interactive_expired?("down",@time) then     
              @currentPuyo.stop_interactive("down")
              @currentPuyo.resume_background("fall",@time)
            end
          end
        when "right"
          if rl_collision && @explode==0 then
            @currentPuyo.go_back_interactive("right")
          else
            if @currentPuyo.interactive_expired?("right",@time) then      
              @currentPuyo.stop_interactive("right")
            end
          end  
        when "left"
          if rl_collision && @explode==0 then
            @currentPuyo.go_back_interactive("left")
          else
            if @currentPuyo.interactive_expired?("left",@time) then      
              @currentPuyo.stop_interactive("left")
            end
          end         
        when "rleft"
          if rl_collision && @explode==0 then
            @currentPuyo.go_back_interactive("rleft")
          else
            if @currentPuyo.interactive_expired?("rleft",@time) then   
              @currentPuyo.stop_interactive("rleft")
            end
          end
        when "rright"
          if rl_collision && @explode==0 then
            @currentPuyo.go_back_interactive("rright")
          else
            if @currentPuyo.interactive_expired?("rright",@time) then   
              @currentPuyo.stop_interactive("rright")
            end
          end
        end
      }
      
    end
    
    #print_debug("polling")
    
  end
  
  
  def add_puyo_current(puyos)
    
    @currentPuyo.add(puyos)
    
  end
  
  def move_puyo_from_current_to_chart(puyos_id)
    #move puyo
    puyos=@currentPuyo.move(puyos_id)
    
    #puts puyos
    @chartPuyo.add(puyos)
    
  end
  
  def move_puyo_from_chart_to_current(puyos_id)  
    #move puyo  
    puyos=@chartPuyo.move(puyos_id)
    
    #puts "puyo"
    @currentPuyo.add(puyos)
    
  end
  
  def to_s
    return "team: "+@team.to_s+" player: "+@num.to_s
  end
  
  def right_pressed ()
    puts "@"+@team.to_s+" bouge à droite la forme : "#+ @currentPuyo.to_s
    if @stat==FALL then 
      @currentPuyo.move_right(@time,250)
    end
  end
  
  def left_pressed ()
    puts "@"+@team.to_s+" bouge à gauche la forme : "#+ @currentPuyo.to_s
    if @stat==FALL then 
      @currentPuyo.move_left(@time,250)
    end
  end
  
  def down_pressed ()
    puts "@"+@team.to_s+" bouge en bas la forme : "#+ @currentPuyo.to_s
    if @stat==FALL then 
      @currentPuyo.halt_background("fall") 
      @currentPuyo.move_down(@time,100)    
    end
  end
  
  def a_pressed ()
    puts "@"+@team.to_s+" tourne à gauche la forme : "#+ @currentPuyo.to_s
    if @stat==FALL then 
      @currentPuyo.rotate_left(@time,250)
    end
  end
  def b_pressed ()
    puts "@"+@team.to_s+" tourne à droite la forme : "#+ @currentPuyo.to_s
    if @stat==FALL then  
      @currentPuyo.rotate_right(@time,250)
    end
  end
  
  def change_lighting()
    if @lighting then @lighting=false else @lighting=true end
  end
  
  def print_debug(head)
    if @num==0 && DEBUG then
      if @newframe then
        puts "**************************************************************"
        puts "*** frame: "+@framecount.to_s+" time: "+@time.to_s+" s"
        puts "*** "+self.to_s
        puts "**************************************************************"
        @newframe=false     
      end
      if @stat==0 then status="WAIT" end
      if @stat==1 then status="FALL" end
      if @stat==2 then status="COLLISION" end
      if @stat==3 then status="FALL2" end
      if @stat==4 then status="EXPLODE" end
      puts "location: glplayer->"+head
      puts "status: "+status
      puts @currentPuyo.to_s
      puts "**************************************************************"
    end
  end
  
end
