require "scenetree.rb"
require 'math3d'

class GLcamera < Node
	def initialize()
	 super()
	 system_inverse()
	end
	def inspect()
      str = ""
      str << "<GLcamera:0x%x"%(self.object_id*2)+">\n"
      return str
    end
	def inspect_private()
	  str=""
	  str << super+"\nSystem  Coord Inverse: \n"+@system_coord_inverse.inspect
	  return str
    end
    def update_coord()
      super
      system_inverse()
    end
  def get_system_coord_inverse()
    return @system_coord_inverse
  end
protected
  def system_inverse()
    @system_coord_inverse=@system_coord.dup.invert_full!  
  end
end