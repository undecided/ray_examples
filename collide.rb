require 'rubygems'
require 'ray'

RECT = [-10, -10, 20, 20]
def rectangle_to_rect_array(rectangle)
  [RECT[0] + rectangle.x, RECT[1] + rectangle.y] + RECT[2..3]
end

def make_rect(rectangle)
  rectangle_to_rect_array(rectangle).to_rect
end

def collision?(a, b)
  ra, rb = make_rect(a), make_rect(b)
  ra.collide? rb
end

Ray.game "Test" do
  register { add_hook :quit, method(:exit!) }

  scene :square do
    @all = []
    @rect = Ray::Polygon.rectangle(RECT, Ray::Color.red)
    
    on :mouse_motion do |pos|
      @rect.color = @all.find { |static| collision? @rect, static } ? Ray::Color.blue : Ray::Color.red
      @rect.pos = pos
    end
    
    on :mouse_press do
      @all << @rect.dup
    end

    always do
      @all.each { |r| r.pos += [-1, 0]} if holding? :left
      @all.each { |r| r.pos += [1, 0]} if holding? :right
      @all.each { |r| r.pos += [0, 1]} if holding? :down
      @all.each { |r| r.pos += [0, -1]} if holding? :up
    end

    render do |win|
      @all.each {|r| win.draw r }
      win.draw @rect
    end
    
  end

  scenes << :square
end
