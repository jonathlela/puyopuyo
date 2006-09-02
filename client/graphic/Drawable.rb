module Drawable
  @meshes
  def draw()
    GL.PushMatrix()
    GL.MultMatrix(@transform.to_a)
    GL.CallList(@meshes)
    GL.PopMatrix()
  end
end