# Author::    Jonathan Marchand  (mailto:first_name.last_name@azubato.net)
# Copyright:: Copyright (c) 2006 Jérémy Marchand & Jonathan Marchand
# License::   GNU General Public License (GPL) version 2

#--###########################################################################
# PuyoPuyo - a PuyoPuyo-like puzzle game                                     #
# Copyright © 2006 Jérémy Marchand & Jonathan Marchand                       #
# Mails : first_name.last_name@azubato.net                                   #
#                                                                            #
# PuyoPuyo is free software; you can redistribute it and/or modify           #
# it under the terms of the GNU General Public License as published by       #
# the Free Software Foundation; either version 2 of the License, or          #
# (at your option) any later version.                                        #
#                                                                            #
# PuyoPuyo is distributed in the hope that it will be useful,                #
# but WITHOUT ANY WARRANTY; without even the implied warranty of             #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
# GNU General Public License for more details.                               #
#                                                                            #
# You should have received a copy of the GNU General Public License          #
# along with PuyoPuyo; if not, write to the Free Software                    #
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA #
##############################################################################

require "puyo.rb"
require "puyochain.rb"

# A Puyo Chart represents the layout of the player's puyos.

class PuyoChart 

  attr_reader :width, :height, :chart, :chains
  
  # Create an empty chart of puyos with the following _width_ and _height_.
  
  def initialize(width,height)
    @width = width
    @height = height
    @chart = Array.new(@height).map{Array.new(@width)}
    @chains = Array.new()
  end
   
  # Add the _puyo_ in the chart in _(a,b)_.
   
  def add_puyo(puyo,a,b)
    @chart[a][b] = puyo
    puyo.set_position(a,b)
    if puyo.type == Puyo::PUYOCOLOR
      chain = PuyoChain.new(puyo)
      puyo_connex = get_connex_puyos_from_color(a,b,puyo.color)
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
  
  # Delete the _puyo_ from the chart.
  
  def delete_puyo(puyo)
    if puyo.type == Puyo::PUYOCOLOR
      @chains.delete(puyo.chain)
      puyo.leave_chain()
    end
    @chart[puyo.coordinates[0]][puyo.coordinates[1]] = nil
  end
  
  # Gives the puyos in the neighborhood of _(a,b)_ in the chart that have the same color as _color_.
  
  def get_connex_puyos_from_color(a,b,color)
    puyo_connex = Array.new()
    # Look if the puyo above's color and add it if necessary.
    if a > 0 && a <= @height - 1
      if @chart[a-1][b] != nil && @chart[a-1][b].type == Puyo::PUYOCOLOR && @chart[a-1][b].color == color
        puyo_connex.push(@chart[a-1][b])
      end
    end
    # Look if the puyo lower's color and add it if necessary.
    if a >= 0 && a < @height - 1
      if @chart[a+1][b] != nil && @chart[a+1][b].type == Puyo::PUYOCOLOR && @chart[a+1][b].color == color
        puyo_connex.push(@chart[a+1][b])
      end
    end
    # Look if the left puyo has the same color and add it if necessary.
    if b > 0 && b <= @width - 1
      if @chart[a][b-1] != nil && @chart[a][b-1].type == Puyo::PUYOCOLOR && @chart[a][b-1].color == color
        puyo_connex.push(@chart[a][b-1])
      end
     end
    # Look if the right puyo has the same color and add it if necessary.
    if b >= 0 && b < @width - 1
      if @chart[a][b+1] != nil && @chart[a][b+1].type == Puyo::PUYOCOLOR && @chart[a][b+1].color == color
        puyo_connex.push(@chart[a][b+1])
      end
    end
    return puyo_connex
  end
  private :get_connex_puyos_from_color
  
  # Gives the puyos that can be erased from the chart.
    
  def get_exploding_puyos()
    exploding_puyos = Array.new()
    @chains.each { |chain|
      if chain.size >= 4
        chain.each { |puyo|
          exploding_puyos.push(puyo)
          puyo_connex = get_connex_puyos_from_type(puyo.row,puyo.column,Puyo::OJAMAPUYO)
          exploding_puyos.concat(puyo_connex)
          puyo_connex.each { |puyo_co|
            exploding_puyos.push(puyo_co)
          }
        }
      end
    }
    return exploding_puyos.uniq()
  end
  
  # Gives the puyos in the neighborhood of _(a,b)_ in the chart that have the same type as _type_.
  
  def get_connex_puyos_from_type(a,b,type)
    puyo_connex = Array.new()
    # Look if the puyo above's type and add it if necessary.
    if a > 0 && a <= @height - 1
      if @chart[a-1][b] != nil && @chart[a-1][b].type == type
        puyo_connex.push(@chart[a-1][b])
      end
    end
     # Look if the puyo above's type and add it if necessary.   
    if a >= 0 && a < @height - 1
      if @chart[a+1][b] != nil && @chart[a+1][b].type == type
        puyo_connex.push(@chart[a+1][b])
      end
    end
    # Look if the puyo above's type and add it if necessary.
    if b > 0 && b <= @width - 1
      if @chart[a][b-1] != nil && @chart[a][b-1].type == type
        puyo_connex.push(@chart[a][b-1])
      end
     end
    # Look if the puyo above's color and add it if necessary.
    if b >= 0 && b < @width - 1
      if @chart[a][b+1] != nil && @chart[a][b+1].type == type
        puyo_connex.push(@chart[a][b+1])
      end
    end
    return puyo_connex
  end
  private :get_connex_puyos_from_type
  
  # Gives the puyos that can fall lower in the chart.
  
  def get_falling_puyos()
    falling_puyos = Array.new()
    height = @height -2
    width = @width -1
    rows = (0..height).to_a.reverse
    columns = (0..width).to_a
    rows.each { |i|
      columns.each { |j|
        if @chart[i][j] != nil && @chart[i-1][j] == nil
          upper_rows = (i..height).to_a.reverse
          upper_rows.each { |k|
            if chart[k][j] != nil
              falling_puyos.push(chart[k][j])
            end
            }
        columns.delete(j)
        end
        }
      }      
    return falling_puyos
  end
  
  # True if the puyos in the chart are in an losing state (BANTAKYU!!!)
  
  def batankyu?()
    middle = @width / 2
    return @chart[7][middle] != nil || @chart[7][middle+1] != nil 
  end
  
  def to_s()
    str = ""
    @chart.each_index { |i|
      @chart[i].each_index { |j|
        if @chart[i][j]==nil then str << "x" else str << @chart[i][j].to_s end 
      }
    }
  end

end