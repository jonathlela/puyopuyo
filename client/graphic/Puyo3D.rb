require 'scenetree.rb'
require 'client/graphic/OpenGL/simpleMeshe/SimplePuyo3D.rb'
require 'client/graphic/Drawable.rb'

class Puyo3D < Node
  attr_reader :color, :id
  include Drawable
  def initialize(id,color,row,column)
     super()
     @id=id
     @color=color
     @parent=nil
     set_position(column,-row,0.0)
     @meshes = SimplePuyo3D.getMeshes(@color)
  end
  def to_s
    v1=get_stage_position()
    v2=get_position()
    return super.to_s+" id: "+@id.to_s+" rel_row: "+(-v2.y).to_s+" rel_column: "+v2.x.to_s+" row: "+v1.y.to_s+" column: "+v1.x.to_s+" color: "+@color.to_s
  end
  def get_stage_position()
     v=@system_coord.get_row(3)
     v.x=v.x+2.5
     v.y=12.5-v.y
     v.z=0.0
     return v    
  end
end
