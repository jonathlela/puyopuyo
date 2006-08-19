class Puyo
  @column = -1
  @row = -1
  @@ids=0
  
  
  def initialize
   @@ids+=1
   @id=@@ids
  end
  
  def id
    return @id
  end
  
  def column
    return @column
  end
  
  def row
    return @row
  end
  
  def set_pos(x,y)
    @row = x
    @column = y
  end
  
  def type
    return @type
  end

end

class PuyoColor < Puyo

  def initialize(color)
    super()
    @color = color
    @chain = nil
    @type = 0
  end
  
  def color
    return @color
  end
  
  def chain
    return @chain
  end
  
  def join(chain)
    @chain = chain
  end
  
  def to_s
    return @color.to_s
  end

end

class OjamaPuyo < Puyo

  def initialize()
    super()
    @type = 1
    @color=5
  end
  
    def color
    return @color
  end
  
  def to_s
     return "x"
  end

end