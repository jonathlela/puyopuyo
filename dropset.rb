class Dropset < Array
    
  def initialize()
    @current_id = 0
  end
    
  def next()
    if @current_id == self.size-1
      @current_id = 0
    else
      @current_id += 1
    end
    return self[@current_id-1]
  end
    
end