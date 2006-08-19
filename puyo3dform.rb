class Puyo3dForm < Array
  attr_reader :x, :y, :height, :angle
  attr_writer :x, :y, :height, :angle
  def initialize()
    @x=0
    @y=0
    @angle=0.0
    @height=0
  end
#  def initFromPuyos(puyos)
#      self.clear
#      rowmin=18
#      colmin=6
#      rowmax=0
#      colmax=0
#      puyos.each { |puyo|
#        if colmin > puyo.column then colmin=puyo.column end
#        if rowmin > puyo.row then rowmin=puyo.row end
#        if colmax < puyo.column then colmax=puyo.column end
#        if rowmax < puyo.row then rowmax=puyo.row end
#      }
#      puyos.each { |puyo|
#        self.push(Puyo3D.new(puyo,puyo.row-rowmin,puyo.column-colmin))
#      }
#      @x=colmin
#      @y=rowmin  
#      @height=rowmax-rowmin+1
#  end
  def init(puyos)
    self.clear()
    self.concat(puyos)
    update_bound()
  end
  def add(puyo3d)
    @angle=0.0
    self.push(puyo3d)
    update_bound()
  end 
  def delete(id)
    self.delete_if {|puyo| puyo.id == id}
    update_bound()
  end
  def update_bound()
      if (!self.empty?) then 
        rowmin=18
        colmin=6
        rowmax=0
        colmax=0
        self.each { |puyo3d|
          if colmin > puyo3d.column then colmin=puyo3d.column end
          if rowmin > puyo3d.row then rowmin=puyo3d.row end
          if colmax < puyo3d.column then colmax=puyo3d.column end
          if rowmax < puyo3d.row then rowmax=puyo3d.row end
        }
        self.each { |puyo3d| 
          puyo3d.rel_row=puyo3d.row-rowmin
          puyo3d.rel_column=puyo3d.column-colmin  
        }
        @x=colmin
        @y=rowmin  
        @height=rowmax-rowmin+1
     else
        @x=0
        @y=0
        @height=0      
     end
  end
  def clear()
    while(!self.empty?)
      self.pop
    end
    update_bound()
  end
  def update_position()
    self.each { |puyo3d|
      puyo3d.row=@y.truncate+puyo3d.rel_row
      puyo3d.column=@x.round+puyo3d.rel_column
    }
  end
  def round()
    @x=@x.round
    @y=@y.truncate
  end
  def move(ids)
     puyos=self.select { |puyo| ids.include?(puyo.id) }
     self.delete_if { |puyo| ids.include?(puyo.id) }
     return puyos
  end
  def del(i)
    self.delete_if { |p| p.id==i }
  end
  def get(i)
    puyo=nil;
    self.each { |puyo3d|
      if puyo3d.id==i then puyo=puyo3d end
    }
    return puyo
  end
  def to_s
    str=""
    str << " x: "+@x.to_s+" y: "+@y.to_s+" h: "+@height.to_s+"\n"
    self.each { |puyo3d|
      str << puyo3d.to_s+"\n"
    }
    return str
  end
end