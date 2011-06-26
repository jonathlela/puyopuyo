require "scenetree.rb"
require "rotation.rb"

class CurrentPuyo < Node
  def initialize()
    super()
    @left=false
    @right=false
    @down=false
    @rleft=false
    @rright=false

    @interactive_motion=Array.new
    @background_motion=Array.new
    @halted_motion=Array.new

    @pos_motion=Array.new
    @speed_motion=Array.new
    10.times {
     mot=PosMotion.new
     @pos_motion.push(mot)
     mot=SpeedMotion.new
     @speed_motion.push(mot)
    }
  end

  def move_left(time,time_to_fall_one_step)
    if !@left && !@right && !@down && !@rleft && !@rright then
      current_motion=@pos_motion.pop()
      current_motion.set("left",@position.x,@position.x-1,time,time_to_fall_one_step.to_f/1000)
      @interactive_motion.push(current_motion)
      @left=true
    end
  end
  def move_right(time,time_to_fall_one_step)
    if !@left && !@right && !@down && !@rleft && !@rright then
      current_motion=@pos_motion.pop()
      current_motion.set("right",@position.x,@position.x+1,time,time_to_fall_one_step.to_f/1000)
      @interactive_motion.push(current_motion)
      @right=true
    end
  end
  def move_down(time,time_to_fall_one_step)
    if !@left && !@right && !@down && !@rleft && !@rright then
      current_motion=@speed_motion.pop()
      current_motion.set("down",1000.0/time_to_fall_one_step.to_f,time,0.2)
      @interactive_motion.push(current_motion)
      @down=true
    end
  end
  def fall(time,time_to_fall_one_step)
      current_motion=@speed_motion.pop()
      current_motion.set("fall",1000.0/time_to_fall_one_step.to_f,time,0.0)
      @background_motion.push(current_motion)
  end
  def rotate_left(time,time_to_rotate)
    if !@left && !@right && !@down && !@rleft && !@rright then
       current_motion=@pos_motion.pop()
       current_motion.set("rleft",@angle,@angle+Math::PI/2.0,time,time_to_rotate.to_f/1000)
       @interactive_motion.push(current_motion)
       @rleft=true
    end
  end
  def rotate_right(time,time_to_rotate)
    if !@left && !@right && !@down && !@rleft && !@rright then
       current_motion=@pos_motion.pop()
       current_motion.set("rright",@angle,@angle-Math::PI/2.0,time,time_to_rotate.to_f/1000)
       @interactive_motion.push(current_motion)
       @rright=true
    end
  end


  def background_movement(time)
    @background_motion.each { |motion|
      name=motion.get_label()
      case(name)
        when "fall"
          @position.y-=motion.get_value(time)
      end
    }
  end
  def interactive_movement(time)
    @interactive_motion.each { |motion|
      name=motion.get_label()
      case(name)
        when "down"
          @position.y-=motion.get_value(time)
        when "right"
          @position.x=motion.get_value(time)
        when "left"
          @position.x=motion.get_value(time)
        when "rleft"
          @angle=motion.get_value(time)
          @direction.x=0.0
          @direction.y=0.0
          @direction.z=1.0
        when "rright"
          @angle=motion.get_value(time)
          @direction.x=0.0
          @direction.y=0.0
          @direction.z=1.0
      end
    }
  end

  def get_background_motion()
    mov=Array.new
    @background_motion.each { |motion| mov.push(motion.get_label()) }
    return mov
  end

  def background_expired?(label,time)
    motion=@background_motion.select { |motion| motion.get_label()==label }.first
    return motion.expired?(time)
  end
  def interactive_expired?(label,time)
    motion=@interactive_motion.select { |motion| motion.get_label()==label }.first
    return motion.expired?(time)
  end

  def get_interactive_motion()
    mov=Array.new
    @interactive_motion.each { |motion| mov.push(motion.get_label()) }
    return mov
  end

  def stop_background(label)
    motion=@background_motion.select { |motion| motion.get_label()==label }.first
    if motion.class=="SpeedMotion" then @speed_motion.push(motion) end
    if motion.class=="PosMotion" then @pos_motion.push(motion) end
    @background_motion.delete(motion)
  end
  def stop_interactive(label)
    motion=@interactive_motion.select { |motion| motion.get_label()==label }.first
    if motion.class.to_s=="SpeedMotion" then @speed_motion.push(motion) end
    if motion.class.to_s=="PosMotion" then @pos_motion.push(motion) end
    @interactive_motion.delete(motion)
    case (motion.get_label())
      when "down"
        @down=false
      when "left"
        @left=false
      when "right"
        @right=false
      when "rleft"
        @rleft=false
       when "rright"
        @rright=false
    end
  end
  def stop_all_interactive()
    @interactive_motion.each { |motion|
      if motion.class.to_s=="SpeedMotion" then @speed_motion.push(motion) end
      if motion.class.to_s=="PosMotion" then @pos_motion.push(motion) end
    }
    @interactive_motion.clear()
    @down=false
    @left=false
    @right=false
    @rleft=false
    @rright=false
  end
  def halt_background(label)
    motion=@background_motion.select { |motion| motion.get_label()==label }.first
    if motion!=nil then
      @halted_motion.push(motion)
      @background_motion.delete(motion)
    end
  end
  def resume_background(label,time)
    motion=@halted_motion.select { |motion| motion.get_label()==label }.first
    @background_motion.push(motion)
    @halted_motion.delete(motion)
    if motion.class.to_s=="SpeedMotion" then motion.get_value(time) end
  end
  def stop_all_halted()
    @halted_motion.each { |motion|
      if motion.class.to_s=="SpeedMotion" then @speed_motion.push(motion) end
      if motion.class.to_s=="PosMotion" then @pos_motion.push(motion) end
    }
    @halted_motion.clear()
  end
  def go_back_interactive(label)
    motion=@interactive_motion.select { |motion| motion.get_label()==label }.first
    if motion.class.to_s=="PosMotion" then
      time=motion.go_back()
      interactive_movement(time)
      update()
    end

  end

  def update()
    @transform=Rotation.new(@direction,@angle)
    @transform.set_row(3,@position)
    update_coord()
  end


  def add(puyos)
    reset()
    puyos.each { |puyo| self.add_child(puyo) }
    update_bound()
  end



  def get_puyos()
    return @children
  end

  def move(ids)
     puyos=Array.new
     @children.each { |puyo|
       puyo.set_parent(nil)
       v=puyo.get_stage_position()
       puyo.set_position(v.x,-v.y,0.0)
       puyos.push(puyo)
     }
     @children.clear()

     puyos_to_move=puyos.select { |puyo| ids.include?(puyo.id) }

     self.add(puyos-puyos_to_move)

     return puyos_to_move
  end

  def clear()
    super
    update_bound()
  end

  def update_bound()
    if (!@children.empty?) then
      rowmin=18
      colmin=6
      rowmax=0
      colmax=0
      @children.each { |puyo3d|
        v1=puyo3d.get_stage_position()
        row=v1.y.to_i
        col=v1.x.to_i
        if colmin > col then colmin=col end
        if rowmin > row then rowmin=row end
        if colmax < col then colmax=col end
        if rowmax < row then rowmax=row end
#        puts "cmin: "+colmin.to_s+" cmax: "+colmax.to_s+" rmin: "+rowmin.to_s+" rmax: "+rowmax.to_s
      }
      @children.each { |puyo3d|

         v1=puyo3d.get_stage_position()
         y=v1.y-rowmin
         x=v1.x-colmin
         puyo3d.set_position(x,-y,0.0)
      }
      x=colmin
      y=rowmin
      height=rowmax-rowmin+1
      width=colmax-colmin+1
    else
      x=0
      y=0
      height=0
      width=0
    end
    self.set_position(x,-y,0.0)
  end

  def round()
    @position.x=@position.x.round
    @position.y=-((-@position.y).truncate)
    update()
  end

  def get_stage_position()
     v=@system_coord.get_row(3)
     v.x=v.x+2.5
     v.y=12.5-v.y
     v.z=0.0
     return v
  end
  def upstair?()
    v=get_stage_position()
    if v.y==5.0 then return true end
    return false
  end
  def to_s
    str=""
    v=get_stage_position()
    str << " x: "+v.x.to_s+" y: "+v.y.to_s+"\n"
    @children.each { |puyo3d|
      str << puyo3d.to_s+"\n"
    }
    return str
  end

end
