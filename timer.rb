require 'sdl'

class Timer
  def initialize(maxframes)
    @maxframes=maxframes
    @framecount=0
    @fps=0.0
    @deltaT=0.0
    @newCount=0.0
    @oldCount=0.0
    @time=0.0
    @starttime=Time.now.to_f
  end
  
  def frame()
    @framecount+=1
    @time=Time.now.to_f
    #@time=SDL.getTicks.to_f/1000
    @deltaT=(@time-@newCount).to_f
    @newCount=@time    
    if @framecount >= @maxframes then
      @fps=@maxframes/(@newCount-@oldCount).to_f
      @oldCount=@time
      @framecount=0
    end
  end
  
  def get_start_time() return @starttime end
  
  def get_deltaT() return @deltaT end
  
  def get_fps() return @fps end
  
  def get_time() return @time-@starttime end
  
end