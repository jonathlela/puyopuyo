class Control2 

  def initialize (lighting,frame_limit)
    @lighting = lighting
    @frame_limit = frame_limit
  end

  def engine
    return @engine
  end
  
  def engine= (engine)
    @engine = engine
  end
  
  def lighting_pressed?()
  end

  def frame_limit_pressed?()
  end
  
  def listen
    control = Thread.new() {
      #while !@player.batankyu? do
      while true do
        if lighting_pressed?()
          @engine.lighting_pressed
        elsif frame_limit_pressed?()
          @engine.frame_limit_pressed
        end
        sleep(0.050)
      end
    }
  end

end