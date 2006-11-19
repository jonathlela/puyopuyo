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
require "position.rb"

#

class PuyoForm

  def initialize
    @chart = (1..2).map {Array.new(2)}
  end

  def instanciate(player,equilibrium,difficulty)   
    color1 = equilibrium.get_color(player,player.nb_puyos,difficulty)
    puyos = Array.new
    @chart.each_index { |row|
      @chart[row].each_index { |column|
        if @chart[row][column] != nil
          if @chart[row][column] == 1
            puyo = PuyoColor.new(color1)
                      puyo.set_position(row+5,column+2)
          elsif @chart[row][column] == 2
            puyo = PuyoColor.new(equilibrium.get_color(player,player.nb_puyos,difficulty))
                      puyo.set_position(row+5,column+2)
          else @chart[row][column] == 3
            puyo = PuyoColor.new(equilibrium.get_color_different(player,player.nb_puyos,difficulty,color1))
                      puyo.set_position(row+5,column+2)
          end
          #puyo.set_position(row+5,column+2)
          puyos.push(puyo)
        end
      }
    }
    return puyos
  end
  
  def to_s
    @chart.each { |puyo|
      puts puyo
    }
  end

end

class Puyos2 < PuyoForm
  
  def initialize()
    super
    @chart[0][0] = 1
    @chart[1][0] = 2
  end
  
end

class Puyos3 < PuyoForm
  
  def initialize
    super
    @chart[0][0] = 1
    @chart[1][0] = 1
    @chart[1][1] = 2
  end
  
end

class Puyos2x2 < PuyoForm
  
  def initialize
    super
    @chart[0][0] = 1
    @chart[0][1] = 3
    @chart[1][0] = 1
    @chart[1][1] = 3
  end
  
end

class Puyos4 < PuyoForm
  
  def initialize
    super
    @chart[0][0] = 1
    @chart[0][1] = 1
    @chart[1][0] = 1
    @chart[1][1] = 1
  end
  
end