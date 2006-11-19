require 'scenetree.rb'
require 'client/graphic/OpenGL/simpleMeshe/SimpleStage3D.rb'
require 'client/graphic/Drawable.rb'

class Stage3D < Node
  include Drawable
  def initialize()
    super()
    @parent=nil
    @meshes = SimpleStage3D.getMeshes()
  end
end

