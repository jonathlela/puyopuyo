require 'rexml/document'
require "dropset.rb"
require "puyoform.rb"

class Character
  
  def initialize(character)
    xml = REXML::Document.new(File.open("character.xml"))
    chars = xml.root.each_element("//character[@id=\'"+character+"\']") { |char|  
      @name =  char.attribute("id")
      @dropset = Dropset.new()
      char.each_element("dropset/drop") { |drop|
        if drop.get_text() == "2"
          @dropset.push(Puyos2.new())
        elsif drop.get_text() == "3"
          @dropset.push(Puyos3.new())
        elsif drop.get_text() == "2x2"
          @dropset.push(Puyos2x2.new())
        elsif drop.get_text() == "4"
          @dropset.push(Puyos4.new())
        end
      }
    }
  end
  
  def dropset
    return @dropset  
  end
  
end