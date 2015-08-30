class GameObject
  attr_reader :x, :y, :width, :height
  
  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end
  
  def colliding_with?(other)
    if other.x > @x + @width
      return false
    elsif other.x + other.width < @x
      return false
    elsif other.y > @y + @height
      return false
    elsif other.y + other.height < @y
      return false
    end
    return true
  end
end
