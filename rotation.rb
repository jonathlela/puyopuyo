require 'matrix'
require 'vector3.rb'
require 'vector4.rb'

class Rotation

  def initialize(*args)
    @array = Array.new(4) { Array.new(4) { 0.0 } }
    case args.size
    when 0
      @array = Array.new(4) { Array.new(4) { 0.0 } }
      @array[0][0] = 1.0
      @array[1][1] = 1.0
      @array[2][2] = 1.0
      @array[3][3] = 1.0
    when 2
      direction = args[0]
      angle = args[1]
      norm = direction.norm()
      u = direction.x.fdiv norm
      v = direction.y.fdiv norm
      w = direction.z.fdiv norm
      u_sqr = u ** 2
      v_sqr = v ** 2
      w_sqr = w ** 2
      sin_val = Math.sin angle
      cos_val = Math.cos angle
      @array[0][0] = u_sqr + (1.0 - u_sqr) * cos_val
      @array[0][1] = u * v * (1.0 - cos_val) + w * sin_val
      @array[0][2] = u * w * (1.0 - cos_val) - v * sin_val
      @array[1][0] = u * v * (1.0 - cos_val) - w * sin_val
      @array[1][1] = v_sqr + (1.0 - v_sqr) * cos_val
      @array[1][2] = v * w * (1.0 - cos_val) + u * sin_val
      @array[2][0] = u * w * (1.0 - cos_val) + v * sin_val
      @array[2][1] = v * w * (1.0 - cos_val) - u * sin_val
      @array[2][2] = w_sqr + (1.0 - w_sqr) * cos_val
      @array[3][3] = 1.0
    else
      error
    end
  end

  def get_row(i)
    return Vector3.new(@array[i][0], @array[i][1], @array[i][2])
  end

  def set_row(i, vector)
    @array[i][0] = vector.x
    @array[i][1] = vector.y
    @array[i][2] = vector.z
  end

  def invert_full!()
    @array = Matrix[*@array].inv().to_a
    return self
  end

  def post_mult!(matrix)
    @array = (Matrix[*@array] * Matrix[*matrix.to_a]).to_a
    return self
  end

  def to_a
    return @array
  end

  def transpose
    return Matrix[*@array].transpose.to_a
  end

end
