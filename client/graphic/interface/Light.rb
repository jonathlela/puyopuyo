class Light < Node

  @enabled = false
  @color = [1.0, 1.0, 1.0]

  def switch()
    @enabled = !@enabled
    if @enabled == true then turn_off() end
    if @enabled == false then turn_on() end
  end

  def switch_on()
    @enbled = true
    turn_on()
  end
  
  def switch_off()
    @enbled = false
    turn_off()
  end

  def get_color()
    return @color
  end
  
  def set_color(*color)
    if(color.length == 1)
      @color = color
    elsif (color.length == 3)
      @color = [color[0],color[1],color[2]]
    else
      raise "wrong number of arguments ("+color.length.to_s+" for 1 or 3)"
    end
    apply_color()
  end
  
end