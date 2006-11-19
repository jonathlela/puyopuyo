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

require "position.rb"

# The Puyos are the basic elements of the game.

class Puyo

  PUYOCOLOR=0
  OJAMAPUYO=1

  attr_reader :id, :position, :type

  @@ids=0

  def initialize()
    @@ids+=1
    @id=@@ids
    @position = UndefinedPosition.new()
  end
  
  # Set the _position_ of the puyo in the world space by setting his _coordinates_.
  
  def set_position(*coordinates)
    @position = DefinedPosition.new(coordinates)
  end


end

# The Puyos that the player control, they have different colors and can be rearranged to make chains.

class PuyoColor < Puyo

  attr_reader :color, :chain

  def initialize(color)
    super()
    @color = color
    @chain = nil
    @type = PUYOCOLOR
  end
  
  # Let the puyo join a _chain_ of puyos.
    
  def join(chain)
    @chain = chain
    @chain.push(puyo)
  end
  
  def leave_chain()
    @chain.delete(self)
    @chain = nil
  end

  def to_s
    return @color.to_s
  end

end

# The Puyos that the opponent sent, they can't be chained.

class OjamaPuyo < Puyo

  attr_reader :color

  def initialize()
    super()
    @type = OJAMAPUYO
    @color = 5
  end
    
   def to_s
    return "x"
  end

end