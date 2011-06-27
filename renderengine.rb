class RenderEngine

  def initialize(graphic_engine,sound_engine,control_engine)
    @graphic_engine = graphic_engine
    @sound_engine = sound_engine
    @control_engine = control_engine
  end

  def game= (game)
    @game = game
    @graphic_engine.game = @game
  end

  def game()
    return @game
  end

  def render
    @graphic_engine.render()
  end

  def ojamafall(player,old_puyos,puyos_to_fall,velocity)
    time = Time.now+0.1
    old_puyos.each { |puyo|
      @graphic_engine.delete_puyo_current(player,puyo,time)
    }
    @graphic_engine.add_puyo_current(player,puyos_to_fall,time)
#    puyos_to_fall.each { |puyo|
#      @graphic_engine.add_puyo_current(player,puyo,time)
#    }
    @graphic_engine.down(player,velocity)
    @graphic_engine.faaaaall(player,time)
    #@sound_engine.faaaaall(player,time)
  end

  def switch(player,old_puyos,puyos_to_fall,velocity)
    time = Time.now+0.1
    puts "player"
    puts player
    old_puyos.each { |puyo|
      @graphic_engine.delete_puyo_current(player,puyo,time)
    }
    @graphic_engine.add_puyo_current(player,puyos_to_fall,time)
    #puyos_to_fall.each { |puyo|
    #  @graphic_engine.add_puyo_current(player,puyo,time)
    #}
    @graphic_engine.down(player,velocity)
  end

  def explod(player,puyos)
    time = Time.now+0.1
     @graphic_engine.explod(player,puyos,200,time)
#    puyos.each { |puyo|
#      @graphic_engine.explod(player,puyo,200,time)
#      @graphic_engine.delete_puyo_chart(player,puyo,time)
#     }
  end

  def fall(player,old_puyos,puyos_to_fall,velocity)
    time = Time.now+0.1
    old_puyos.each { |puyo|
      @graphic_engine.delete_puyo_current(player,puyo,time)
    }
    @graphic_engine.move_puyo_from_chart_to_current(player,puyos_to_fall,time)
#    puyos_to_fall.each { |puyo|
#      puts "delete chart"
#      @graphic_engine.delete_puyo_chart(player,puyo,time)
#      puts "add current"
#      @graphic_engine.add_puyo_current(player,puyo,time)
#    }
    @graphic_engine.down(player,velocity)
  end

  def update(player,puyos_to_add,puyos_to_delete)
    time = Time.now+0.1
    @graphic_engine.move_puyo_from_current_to_chart(player,puyos_to_add,time)
#    puyos_to_add.each { |puyo|
#      @graphic_engine.add_puyo_chart(player,puyo,time)
#    }
#    puyos_to_delete.each { |puyo|
#      @graphic_engine.delete_puyo_current(player,puyo,time)
#    }
  end

  def continue(player,puyos_to_fall,velocity)
    time = Time.now+0.1
    #@graphic_engine.add_puyo_current(player,puyos_to_fall,time)
#    puyos_to_fall.each { |puyo|
#      @graphic_engine.add_puyo_current(player,puyo,time)
#    }
    @graphic_engine.down(player,velocity)
  end

  def move_left(player,time_to_fall_one_step)
    @graphic_engine.move_left(player,time_to_fall_one_step)
  end

  def move_right(player,time_to_fall_one_step)
    @graphic_engine.move_right(player,time_to_fall_one_step)
  end

  def move_down(player,time_to_fall_one_step)
    @graphic_engine.move_down(player,time_to_fall_one_step)
  end

  def rotate_clockwise(player,time_to_rotate,puyo_rotation)
    @graphic_engine.rotate_clockwise(player,time_to_rotate,puyo_rotation)
  end

  def rotate_anticlockwise(player,time_to_rotate,puyo_rotation)
    @graphic_engine.rotate_anticlockwise(player,time_to_rotate,puyo_rotation)
  end

  def change_color(player,color)
    @graphic_engine.change_color(player,color)
  end



end
