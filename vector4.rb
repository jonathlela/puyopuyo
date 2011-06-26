class Vector4

  def initialize(*args)
    @array = Array.new(4) { |i| args[i] }
  end

  def x()
    return @array[0]
  end

  def x=(nx)
    @array[0] = nx
  end

  def y()
    return @array[1]
  end

  def y=(ny)
    @array[1] = ny
  end

  def z()
    return @array[2]
  end

  def z=(nz)
    @array[2] = nz
  end

  def t()
    return @array[3]
  end

  def t=(nt)
    @array[3] = nt
  end

  def norm()
    res = 0
    @array.each { |i|
      res += i**2
    }
    return Math.sqrt(res)
  end

end
