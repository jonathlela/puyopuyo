require "puyo.rb"

class PuyoChain < Array
  
  def initialize(puyo)
    self.push(puyo)
    puyo.join(self)
  end
  
end
