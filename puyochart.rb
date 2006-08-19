require "puyo.rb"
require "puyochain.rb"

class PuyoChart 

  def initialize()
    @chart = Array.new(19).map{Array.new(6)}
    @chains = Array.new
  end
  
  def chains
    return @chains
  end
  
  def chart
    return @chart  
  end
  
  def chart= (chart)
    @chart = chart  
  end
  
  def add_puyo(a,b,puyo)
    @chart[a][b] = puyo
    #puts self.to_s
    puyo.set_pos(a,b)
    if puyo.type == 0
      #puts a.to_s+" "+b.to_s
      chain = PuyoChain.new(puyo)
      puyo_connex = get_connex_puyos_from_color(a,b,puyo.color)
      puyo_connex
      puyo_connex.each { |puyo_co|
        if chain != puyo_co.chain
          old = puyo_co.chain
          puyo_co.chain.each { |puyo_co_plus|
              puyo_co_plus.join(chain)
              chain.push(puyo_co_plus)
          }
          @chains.delete(old)
        end
      }
      @chains.push(chain)
    end
  end
  
  def delete_puyo(puyo)
    if puyo.type == 0
      @chains.delete(puyo.chain)
    end
    @chart[puyo.row][puyo.column] = nil
  end
  
  def get_connex_puyos_from_color(a,b,color)
    #puts a.to_s+" "+b.to_s
    puyo_connex = Array.new
    if a > 0 && a <= 18
      #puts "haut? "+a.to_s+" "+b.to_s
      #puts @chart[a-1][b]
      if @chart[a-1][b] != nil && @chart[a-1][b].type == 0 && @chart[a-1][b].color == color
        puyo_connex.push(@chart[a-1][b])
      end
    end
    if a >= 0 && a < 18
      #puts "bas? "+a.to_s+" "+b.to_s
      if @chart[a+1][b] != nil then 
       # puts "type: "+@chart[a+1][b].type.to_s
       # puts "color: "+@chart[a+1][b].color.to_s+" color: "+color.to_s
       # puts @chart[a+1][b].color.class
       # puts color.class
      end
      #puts @chart[a+1][b] != nil
      #puts @chart[a+1][b].type == 0
      #puts @chart[a+1][b].color == color
      if @chart[a+1][b] != nil && @chart[a+1][b].type == 0 && @chart[a+1][b].color == color
        #puts "bas"
        puyo_connex.push(@chart[a+1][b])
        #puts puyo_connex
      end
    end
    if b > 0 && b <= 5
      if @chart[a][b-1] != nil && @chart[a][b-1].type == 0 && @chart[a][b-1].color == color
        puyo_connex.push(@chart[a][b-1])
      end
     end
    if b >= 0 && b < 5
      if @chart[a][b+1] != nil && @chart[a][b+1].type == 0 && @chart[a][b+1].color == color
        puyo_connex.push(@chart[a][b+1])
      end
    end
    return puyo_connex
  end
  private :get_connex_puyos_from_color
  
  def get_connex_puyos_from_type(a,b,type)
    puyo_connex = Array.new
    if a > 0 && a <= 18
      if @chart[a-1][b] != nil && @chart[a-1][b].type == type
        puyo_connex.push(@chart[a-1][b])
      end
    end
    if a >= 0 && a < 18
      if @chart[a+1][b] != nil && @chart[a+1][b].type == type
        puyo_connex.push(@chart[a+1][b])
      end
    end
    if b > 0 && b <= 5
      if @chart[a][b-1] != nil && @chart[a][b-1].type == type
        puyo_connex.push(@chart[a][b-1])
      end
     end
    if b >= 0 && b < 5
      if @chart[a][b+1] != nil && @chart[a][b+1].type == type
        puyo_connex.push(@chart[a][b+1])
      end
    end
    return puyo_connex
  end
  private :get_connex_puyos_from_type
   
  def get_exploding_puyos()
    exploding_puyos = Array.new
    @chains.each { |chain|
      if chain.size >= 4
        chain.each { |puyo|
          exploding_puyos.push(puyo)
          puyo_connex =  get_connex_puyos_from_type(puyo.row,puyo.column,OjamaPuyo.new.type)
          puyo_connex.each { |puyo_co|
            exploding_puyos.push(puyo_co)
          }
        }
      end
    }
    return exploding_puyos.uniq
  end
  
  def get_falling_puyos()
    falling_puyos = Array.new
    @chart.each_index { |i|
      if @chart[i] != nil && i < 18
        @chart[i].each_index { |j|
          if @chart[i][j] != nil && @chart[i+1][j] == nil
            (0..i).map { |k|
              if @chart[k][j] != nil
                falling_puyos.push(@chart[k][j])
                delete_puyo(@chart[k][j])
              end
            }
          end
        }
      end
    }
    puts "fall"+falling_puyos.to_s
    return falling_puyos
  end
  
  def batankyu?()
    return @chart[7][2] != nil || @chart[7][3] != nil 
  end
  
  def to_s
    str = ""
    @chart.each_index { |i|
      @chart[i].each_index { |j|
        if @chart[i][j]==nil then str << "x" else str << @chart[i][j].to_s end 
        #str+="["+i.to_s+"]["+j.to_s+"]"+@chart[i][j].to_s

      }
      puts str
      str="" 
    }
    #puts "fin"
    #return str
  end
  def print()
  end
end