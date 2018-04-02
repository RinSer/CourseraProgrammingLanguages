# University of Washington, Programming Languages, Homework 7, hw7.rb 
# (See also ML code)

# a little language for 2D geometry objects

# each subclass of GeometryExpression, including subclasses of GeometryValue,
#  needs to respond to messages preprocess_prog and eval_prog
#
# each subclass of GeometryValue additionally needs:
#   * shift
#   * intersect, which uses the double-dispatch pattern
#   * intersectPoint, intersectLine, and intersectVerticalLine for 
#       for being called by intersect of appropriate clases and doing
#       the correct intersection calculuation
#   * (We would need intersectNoPoints and intersectLineSegment, but these
#      are provided by GeometryValue and should not be overridden.)
#   *  intersectWithSegmentAsLineResult, which is used by 
#      intersectLineSegment as described in the assignment
#
# you can define other helper methods, but will not find much need to

# Note: geometry objects should be immutable: assign to fields only during
#       object construction

# Note: For eval_prog, represent environments as arrays of 2-element arrays
# as described in the assignment

class GeometryExpression  
  # do *not* change this class definition
  Epsilon = 0.00001
end

class GeometryValue 
  # do *not* change methods in this class definition
  # you can add methods if you wish

  private
  # some helper methods that may be generally useful
  def real_close(r1,r2) 
    (r1 - r2).abs < GeometryExpression::Epsilon
  end
  def real_close_point(x1,y1,x2,y2) 
    real_close(x1,x2) && real_close(y1,y2)
  end
  # two_points_to_line could return a Line or a VerticalLine
  def two_points_to_line(x1,y1,x2,y2) 
    if real_close(x1,x2)
      VerticalLine.new x1
    else
      m = (y2 - y1).to_f / (x2 - x1)
      b = y1 - m * x1
      Line.new(m,b)
    end
  end

  public
  # we put this in this class so all subclasses can inherit it:
  # the intersection of self with a NoPoints is a NoPoints object
  def intersectNoPoints np
    np # could also have NoPoints.new here instead
  end

  # we put this in this class so all subclasses can inhert it:
  # the intersection of self with a LineSegment is computed by
  # first intersecting with the line containing the segment and then
  # calling the result's intersectWithSegmentAsLineResult with the segment
  def intersectLineSegment seg
    line_result = intersect(two_points_to_line(seg.x1,seg.y1,seg.x2,seg.y2))
    line_result.intersectWithSegmentAsLineResult seg
  end
end

class NoPoints < GeometryValue
  # do *not* change this class definition: everything is done for you
  # (although this is the easiest class, it shows what methods every subclass
  # of geometry values needs)
  # However, you *may* move methods from here to a superclass if you wish to

  # Note: no initialize method only because there is nothing it needs to do
  def eval_prog env 
    self # all values evaluate to self
  end
  def preprocess_prog
    self # no pre-processing to do here
  end
  def shift(dx,dy)
    self # shifting no-points is no-points
  end
  def intersect other
    other.intersectNoPoints self # will be NoPoints but follow double-dispatch
  end
  def intersectPoint p
    self # intersection with point and no-points is no-points
  end
  def intersectLine line
    self # intersection with line and no-points is no-points
  end
  def intersectVerticalLine vline
    self # intersection with line and no-points is no-points
  end
  # if self is the intersection of (1) some shape s and (2) 
  # the line containing seg, then we return the intersection of the 
  # shape s and the seg.  seg is an instance of LineSegment
  def intersectWithSegmentAsLineResult seg
    self
  end
end


class Point < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods

  # Note: You may want a private helper method like the local
  # helper function inbetween in the ML code
  attr_reader :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end
  # methods added start
  def eval_prog env 
    self # all values evaluate to self
  end
  def preprocess_prog
    self # no pre-processing to do here
  end
  def shift(dx,dy)
    Point.new(self.x + dx, self.y + dy)
  end
  def intersect other
    other.intersectPoint self
  end
  def intersectPoint p
    real_close_point(self.x, self.y, p.x, p.y) ? self : NoPoints.new
  end
  def intersectLine line
    real_close(self.y, line.m * self.x + line.b) ? self : NoPoints.new
  end
  def intersectVerticalLine vline
    real_close(self.x, vline.x) ? self : NoPoints.new
  end
  def intersectWithSegmentAsLineResult seg
    if inbetween(self.x, seg.x1, seg.x2) and inbetween(self.y, seg.y1, seg.y2)
      Point.new(self.x, self.y)
    else
      NoPoints.new
    end
  end
  private
  # helper method to determine if number is between two other
  def inbetween(v, end1, end2)
    res = (end1 - GeometryExpression::Epsilon <= v and v <= end2 + GeometryExpression::Epsilon)
    res or (end2 - GeometryExpression::Epsilon <= v and v <= end1 + GeometryExpression::Epsilon)
  end
  # methods added fin
end

class Line < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  attr_reader :m, :b 
  def initialize(m,b)
    @m = m
    @b = b
  end
  # methods added start
  def eval_prog env 
    self # all values evaluate to self
  end
  def preprocess_prog
    self # no pre-processing to do here
  end
  def shift(dx,dy)
    Line.new(self.m, self.b + dy - self.m*dx)
  end
  def intersect other
    other.intersectLine self
  end
  def intersectPoint p
    p.intersectLine self
  end
  def intersectLine line
    if real_close(self.m, line.m)
      real_close(self.b, line.b) ? self : NoPoints.new
    else
      x = (line.b - self.b) / (self.m - line.m)
      y = self.m * x + self.b
      Point.new(x, y)
    end
  end
  def intersectVerticalLine vline
    Point.new(vline.x, self.m * vline.x + self.b)
  end
  def intersectWithSegmentAsLineResult seg
    seg
  end
  # methods added fin
end

class VerticalLine < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  attr_reader :x
  def initialize x
    @x = x
  end
  # methods added start
  def eval_prog env 
    self # all values evaluate to self
  end
  def preprocess_prog
    self # no pre-processing to do here
  end
  def shift(dx,dy)
    VerticalLine.new(self.x + dx)
  end
  def intersect other
    other.intersectVerticalLine self
  end
  def intersectPoint p
    p.intersectVerticalLine self
  end
  def intersectLine line
    line.intersectVerticalLine self
  end
  def intersectVerticalLine vline
    real_close(self.x, vline.x) ? self : NoPoints.new
  end
  def intersectWithSegmentAsLineResult seg
    seg
  end
  # methods added fin
end

class LineSegment < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  # Note: This is the most difficult class.  In the sample solution,
  #  preprocess_prog is about 15 lines long and 
  # intersectWithSegmentAsLineResult is about 40 lines long
  attr_reader :x1, :y1, :x2, :y2
  def initialize (x1,y1,x2,y2)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2
  end
  # methods added start
  def eval_prog env 
    self # all values evaluate to self
  end
  def preprocess_prog
    if real_close_point(self.x1, self.y1, self.x2, self.y2)
      Point.new(self.x1, self.y1)
    elsif (self.x1 > self.x2 and not real_close(self.x1, self.x2)) or self.y1 > self.y2
      LineSegment.new(self.x2, self.y2, self.x1, self.y1)
    else
      self
    end
  end
  def shift(dx,dy)
    LineSegment.new(self.x1+dx, self.y1+dy, self.x2+dx, self.y2+dy)
  end
  def intersect other
    other.intersectLineSegment self
  end
  def intersectPoint p
    p.intersectLineSegment self
  end
  def intersectLine line
    line.intersectLineSegment self
  end
  def intersectVerticalLine vline
    vline.intersectLineSegment self
  end
  def intersectWithSegmentAsLineResult seg
    if real_close(self.x1, self.x2)
      if self.y1 < seg.y1
        seg1 = self
        seg2 = seg
      else
        seg1 = seg
        seg2 = self
      end
      if real_close(seg1.y2, seg2.y1)
          Point.new(seg1.x2, seg1.y2)
        elsif seg1.y2 < seg2.y1
          NoPoints.new
        elsif seg1.y2 > seg2.y2
          LineSegment.new(seg2.x1, seg2.y1, seg2.x2, seg2, y2)
        else
          LineSegment.new(seg1.x1, seg1.y1, seg2.x2, seg2.y2)
        end
    else
      if self.x1 < seg.x1
        seg1 = self
        seg2 = seg
      else
        seg1 = seg
        seg2 = self
      end
      if real_close(seg1.x2, seg2.x1)
        Point.new(seg1.x2, seg1.y2)
      elsif seg1.x2 < seg2.x1
        NoPoints.new
      elsif seg1.x2 > seg2.x2
        LineSegment.new(seg2.x1, seg2.y1, seg2.x2, seg2.y2)
      else
        LineSegment.new(seg2.x1, seg2.y1, seg1.x2, seg1.y2)
      end
    end
  end
  # methods added fin
end

# Note: there is no need for getter methods for the non-value classes

class Intersect < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end
  # methods added start
  def eval_prog env 
    l1 = @e1.eval_prog(env)
    l2 = @e2.eval_prog(env)
    res2 = l1.intersect(l2)
    res2
  end
  def preprocess_prog
    @e1 = @e1.preprocess_prog
    @e2 = @e2.preprocess_prog
    self
  end
  # methods added end
end

class Let < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  # Note: Look at Var to guide how you implement Let
  def initialize(s,e1,e2)
    @s = s
    @e1 = e1
    @e2 = e2
  end
  # methods added start
  def eval_prog env 
    @e1 = @e1.eval_prog(env)
    unless env.any? { |v| v[0] == @s }
      env = [[@s, @e1]] + env
    else
      v = env.find { |v| v[0] == @s }
      v[1] = @e1
    end
    @e2.eval_prog(env)
  end
  def preprocess_prog
    @e1 = @e1.preprocess_prog
    @e2 = @e2.preprocess_prog
    self
  end
  # methods added end
end

class Var < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize s
    @s = s
  end
  def eval_prog env # remember: do not change this method
    pr = env.assoc @s
    raise "undefined variable" if pr.nil?
    pr[1]
  end
  # methods added start
  def preprocess_prog
    self
  end
  # method added end
end

class Shift < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize(dx,dy,e)
    @dx = dx
    @dy = dy
    @e = e
  end
  # methods added start
  def eval_prog env 
    @e.eval_prog(env).shift(@dx, @dy)
  end
  def preprocess_prog
    @e = @e.preprocess_prog
    self
  end
  # methods added end
end
