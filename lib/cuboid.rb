# A cuboid. Basically a 3D rectangle
class Cuboid
  attr_reader :origin
  attr_accessor :length, :width, :height
  # Create a new Cuboid
  #
  # @param [Array<Fixnum>] origin: Array of [x,y,z]
  # @param [Fixnum] length: Size of cuboid on x axis
  # @param [Fixnum] width: Size of cuboid on z axis
  # @param [Fixnum] height: Size of cuboid on y axis
  # @return [Cuboid] A cuboid object
  def initialize(origin:, length:, width:, height:)
    @origin = Coordinate.new(*origin)
    @length = length # x
    @width = width # z
    @height = height # y
  end

  # Moves the cuboid to new coords, based on its origin
  #
  # @param [Fixnum] x
  # @param [Fixnum] y
  # @param [Fixnum] z
  # @return [Cuboid] The modified cuboid object (self)
  def move_to!(x, y, z)
    @origin = Coordinate.new(x, y, z)
    self
  end

  # Safe version of move_to!
  #
  # @param [Fixnum] x
  # @param [Fixnum] y
  # @param [Fixnum] z
  # @return [Cuboid] New cuboid object
  def move_to(x, y, z)
    dup.move_to!(x, y, z)
  end

  # Returns an array of vertices, arranged based off [this](http://www.ics.uci.edu/~dock/manuals/cgal_manual/Kernel_23_ref/fig/IsoCuboid.gif) illustration
  # (disregard axes, using y = height axis model)
  #
  # @return [Array<Coordinate>] An array of coordinate objects
  def vertices
    # This code repeats a little, but is explicit, whereas a "neater" solution
    # would prove more complicated
    v1 = @origin.dup
    v1.x += @length
    v2 = v1.dup
    v2.z += @width
    v3 = @origin.dup
    v3.z += @width
    v4 = v3.dup
    v4.y += @height
    v5 = @origin.dup
    v5.y += @height
    v6 = v5.dup
    v6.x += @length
    v7 = v6.dup
    v7.z += @width

    [@origin, v1, v2, v3, v4, v5, v6, v7]
  end

  # Deterimnes if 2 cuboids intersect
  #
  # @param [Cuboid] other The other cuboid object
  # @return [Boolean]
  # rubocop:disable Metrics/AbcSize
  def intersects?(other)
    c1 = vertices
    c2 = other.vertices
    # We only have to measure intersections on each axis once, because an axis
    # is not an edge (there are only 3 axes)
    # X
    x1 = Line.new(c1[0].x, c1[1].x)
    x2 = Line.new(c2[0].x, c2[1].x)
    x = x1.intersect? x2
    # Z
    z1 = Line.new(c1[1].z, c1[2].z)
    z2 = Line.new(c2[1].z, c2[2].z)
    z = z1.intersect? z2
    # Y
    y1 = Line.new(c1[2].y, c1[7].y)
    y2 = Line.new(c2[2].y, c2[7].y)
    y = y1.intersect? y2

    (x && y && z)
  end
  # rubocop:enable Metrics/AbcSize
end

# Represents a single 3D coordinate in space
# y axis is assumed to be vertical
class Coordinate
  attr_accessor(:x, :y, :z)

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def ==(other)
    x == other.x && y == other.y && z == other.z
  end
  alias_method :eql?, :==
  alias_method :equal?, :==

  def to_s
    "(#{x}, #{y}, #{z})"
  end

  def to_a
    [x, y, z]
  end
end

# Not a true geometric line, rather, more like a number line.
class Line
  attr_accessor :p1, :p2

  # @param [Fixnum] p1
  # @param [Fixnum] p2
  # @return [Line]
  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
  end

  def intersect?(other_line)
    # First, we sort so that the numbers are ordered increasingly
    a, b  = [[@p1, @p2].sort, [other_line.p1, other_line.p2].sort].sort
    _, a2 = a
    b1, b2, = b
    return true if a2 > b2
    return true if a2 > b1
    false
  end
end
