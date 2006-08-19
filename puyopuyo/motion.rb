class Motion
  def initialize()
    @label=""
    @start_time=0.0
    @end_time=0.0   
  end
  def get_label()
    return @label
  end
end

class PosMotion < Motion
  def initialize()
    @start_value=0.0
    @end_value=0.0
    @time=0.0
    @value=0.0
    @reverse=false
  end
  def set(label,start_value,end_value,start_time,duration)
    @label=label
    @start_value=start_value
    @end_value=end_value
    @start_time=start_time
    @end_time=start_time+duration
    @reverse=false
  end
  def get_value(time)
    @time=time 
    if time < @start_time then return @start_value end
    if time > @end_time then return @end_value end
    @value=(time-@start_time)/(@end_time-@start_time)*(@end_value-@start_value)+@start_value
    return @value
  end
  def expired?(time)
      return time > @end_time
  end
  def to_s
    return super+" label: "+@label+" start_time: "+@start_time.to_s+" end_time: "+@end_time.to_s+" start_value: "+@start_value.to_s+" end_value: "+@end_value.to_s
  end
  def go_back()
    #puts "go_back"
    if !@reverse
      #puts self.to_s
      @end_time=@start_time+(@time-@start_time)*2
      @start_time=@time
      @end_value=@start_value
      @start_value=@value
      #puts self.to_s
      @reverse=true
    end
    return @time
  end
end

class SpeedMotion < Motion
  def initialize()
    @speed=0.0
  end
  def set(label,speed,start_time,duration)
    @label=label
    @speed=speed
    @start_time=start_time
    @end_time=start_time+duration
    @time=@start_time
  end
  def get_value(time)
    if @start_time==@end_time || (time >= @start_time &&  time <= @end_time) then
      value=(time-@time)*@speed
    else 
      value=0.0
    end
    @time=time       
    return value
  end
  def expired?(time)
    if @start_time==@end_time then
      return false
    else    
      return time > @end_time
    end
  end
  def to_s
    return super+" label: "+@label+" start_time: "+@start_time.to_s+" end_time: "+@end_time.to_s+" speed: "+@speed.to_s
  end
end
