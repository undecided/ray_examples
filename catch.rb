require 'rubygems'
require 'ray'

TRAMPOLINE = [-40, -5, 80, 10]
TRAMPOLINE_Y = 550
FALLER = [-10, -10, 20, 20]

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

def set_starting_position_for(rectangle)
  rectangle.pos = [rand(800), 0]
  rectangle
end

Ray.game "Test", :size => [800, 600] do
  register { add_hook :quit, method(:exit!) }

  scene :square do
    @trampoline = Ray::Polygon.rectangle(TRAMPOLINE, Ray::Color.red)
    @all = (1..10).map { set_starting_position_for Ray::Polygon.rectangle(FALLER, Ray::Color.blue) }
    @all_animations = @all.map { |poly| t = translation(:of => [rand(100) - 50, 600], :duration => 3); t.start(poly); t}
    @all_animations.each do |anim|
      animations << anim
      anim.loop!
    end
    
    on :mouse_motion do |pos|
      #@rect.color = @all.find { |static| collision? @rect, static } ? Ray::Color.blue : Ray::Color.red
      @trampoline.pos = [pos.x, TRAMPOLINE_Y]
    end

    render do |win|
      win.draw @trampoline
      @all.each do |faller|
        win.draw faller
      end
    end
    
  end

  scenes << :square
end
