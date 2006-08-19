require 'benchmark'

class FrameContext
  def initialize()
    @dt=0.0
    @time=0.0
    @fps=0.0
    @framecount=0
    @timer=Timer.new(50)
    @max_fps=1.0/60.0
    @limit=true
    update()
    @starttime=@timer.get_start_time()
  end
  def update()
    @timer.frame()
    @dt=@timer.get_deltaT()
    @time=@timer.get_time()
    @fps=@timer.get_fps()
    @framecount+=1
  end
  def wait()
    #bt=Benchmark.realtime() {
      if @limit then
        t=(Time.now.to_f-@starttime)-@time
        t=@max_fps-t-0.00015
        if t>0 then
          sleep(t)
        end
      end
    #}
    #puts bt
  end
  def set_max_fps(fps)
    @max_fps=1.0/fps
  end
  def get_max_fps()
    return 1.0/@max_fps
  end
  def is_limited?()
    return @limit
  end
  def limit()
    @limit=true
  end
  def unlimit()
    @limit=false
  end
  
  def dt() return @dt end
  def time() return @time end
  def fps() return @fps end
  def framecount() return @framecount end
end