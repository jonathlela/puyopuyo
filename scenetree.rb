require 'math3d'
require 'opengl'

class Node
  #DEBUG=true
  DEBUG=false
  @@ident=0
  def initialize()
    init()
  end
  def init()
    @position=Math3d::Vector3.new(0.0,0.0,0.0)
    @direction=Math3d::Vector3.new(0.0,0.0,1.0)
    @angle=0.0
    @transform=Math3d::Matrix4::ident
    @children=Array.new
    @parent=nil
    @objects=Array.new
    @system_coord=Math3d::Matrix4::ident
  end
  def reset()
    @position.x=0.0
    @position.y=0.0
    @position.z=0.0
    @angle=0.0
    @direction.x=0.0
    @direction.y=0.0
    @direction.z=1.0
    @transform.ident()
    update_coord()
  end
  def get_position()
    return @position.dup
  end
  def get_direction()
    return @direction.dup
  end
  def get_angle()
    renturn @angle
  end
  def get_rotation()
    return Math3d::Rotation.new(@direction,@angle)
  end
  def set_position(*position)
    if position.length==3 then
      @position.x=position[0]
      @position.y=position[1]
      @position.z=position[2]
    elsif position.length==1 then
      @position=position
    else 
      raise "wrong number of arguments ("+position.length.to_s+" for 1 or 3)"
    end
    update_position()
  end
  def set_rotation(*rotation)
    if rotation.length==4 then
      @direction.x=rotation[0]
      @direction.y=rotation[1]
      @direction.z=rotation[2]
      @angle=rotation[3]
    elsif rotation.length==2
        @direction=rotation[0]
        @angle=rotation[1]
    elsif rotation.length==1
        @direction=rotation.get_axis()
        @angle=rotation.get_angle()
    else
      raise "wrong number of arguments ("+rotation.length.to_s+" for 1, 2 or 4)"
    end
    update_rotation()
  end
  def clear()
    @children.clear()
  end
  def inspect()
    str = ""
    str << "<Node:0x%x"%(self.object_id*2)+">"
    return str
  end
  def inspect_public()
    str=""
    str << self.inspect+"\n\tposition:\t"+@position.inspect+"\n\tdirection:\t"+@direction.inspect+"\n\tangle:\t\t"+@angle.to_s+"\n\tparent:\t\t"+@parent.inspect
    str << "\n\tobjects:\t["
    size=@objects.length
    if size==0 then str << "empty" else
      @objects.each_index { |i| 
        str << "<"+@objects[i].class.to_s+":0x%x"%(@objects[i].object_id*2)+">"
        if i<size-1 then str << ", " end
      }
    end
    str << "]"
    str << "\n\tchildren:\t["
    size=@children.length
    if size==0 then str << "empty" else
      @children.each_index { |i| 
        str << "<"+@children[i].class.to_s+":0x%x"%(@children[i].object_id*2)+">"
        if i<size-1 then str << ", " end
      }
    end
    str << "]"
    return str
  end
  def inspect_private()
    str=""
    str << self.inspect+"\nTransform: \n"+@transform.inspect+"\nSystem  Coord: \n"+@system_coord.inspect
    return str  
  end
  def add_child(child)
    if @children.include?(child) then raise "already a child of this node" end
    child.set_parent(self)
    @children.push(child)
    child.update_coord()
  end
  def del_child(child)
    if !@children.include?(child) then rasie "not a child of this node" end
    child.set_parent(nil)
    @children.delete(child)
  end
  def set_parent(parent)
    @parent=parent
  end
  def get_parent(parent)
    return @parent
  end
  def add_object(object)
    if @objects.include?(object) then raise "already an object of this node" end
    object.set_parent(self)
    @objects.push(object)
  end
  def del_object(object)
    if !@objects.inclue?(object) then raise "not an object of this node" end
    object.set_parent(nil)
    @objects.delete(object)
  end
  def get_system_coord()
    return @system_coord
  end
  def get_world_position()
    return @system_coord.get_row(3)
  end
  def update_coord()
    if @parent==nil then
      @system_coord=@transform
    else
      @system_coord=@transform.dup.post_mult!(@parent.get_system_coord())
    end
    @children.each { |child| child.update_coord() }
  end
  def draw()
    GL.PushMatrix()
    #########
    #touver fonction load matrix
    GL.MultMatrix(@transform.to_a)
    #########
    @objects.each { |object| object.draw() }
    if DEBUG then
      str=""
      @@ident.times {str << "\t" }
      @@ident+=1
      str << self.inspect
      puts str
    end
    @children.each { |child| child.draw() }
    if DEBUG then @@ident-=1 end
    GL.PopMatrix()
  end
protected
  def update_position()
    @transform.set_row(3,@position)
    update_coord()
  end
  def update_rotation()
    @transform=Math3d::Matrix4::rotate(@direction,@angle)
    update_position()
  end
end