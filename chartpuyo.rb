require "scenetree.rb"

class ChartPuyo < Node
  def move(ids)
     puyos=@children.select { |puyo| ids.include?(puyo.id) }
     puyos.each { |puyo|
       puyo.set_parent(nil)
       @children.delete(puyo)
     }
     return puyos
  end
  def get_puyos()
    return @children
  end
  def add(puyos)
    puyos.each { |puyo| 
      self.add_child(puyo)
    }
  end  
end