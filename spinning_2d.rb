require 'rubygems'
require 'ray'

class ScreensaverScene < Ray::Scene
  scene_name :screensaver

  def triangle(a, b, c)
    tri = Ray::Polygon.new
    tri.add_point(a, Ray::Color.green, Ray::Color.white)
    tri.add_point(b, Ray::Color.green, Ray::Color.white)
    tri.add_point(c, Ray::Color.green, Ray::Color.white)
    tri.filled   = false
    tri.outlined = true
    tri.outline_width = 10
    tri
  end
  
  def spin(x)
    @spinner = rotation(:from => 0, :to => 360, :duration => 2)
    @spinner.start(x)
    @spinner.loop!
  end
  
  def percentage_position(x, y)
    [(Ray.screen_size.width * x) / 100, (Ray.screen_size.height * y) / 100]
  end
  alias :pp :percentage_position

  def setup
    @triangle = triangle(pp(0, -20), pp(-20, 20), pp(20,20))
    @triangle.pos = pp(50,50)
    spin(@triangle)
  end
  
  def register
    always do
      @spinner.update
    end
  end
  
  def render(win)
    win.draw @triangle
  end
end


class Game < Ray::Game
  def initialize
    super "Awesome Game", :fullscreen => true, :size => Ray.screen_size

    ScreensaverScene.bind(self)

    scenes << :screensaver
  end
  
  def register
    add_hook :key_press, method(:exit!)
  end
end

Game.new.run
