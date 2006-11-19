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

# A DropSet

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