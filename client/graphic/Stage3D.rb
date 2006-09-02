require 'scenetree.rb'
require 'client/graphic/simpleMeshe/SimpleStage3D.rb'
require 'client/graphic/Drawable'

class Stage3D < Node
  include Drawable
  def initialize()
    super()
    @parent=nil
    @meshes = SimpleStage3D.getMeshes()
  end
end

