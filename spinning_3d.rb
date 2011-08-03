require 'rubygems'
require 'ray'


# Notice an artifact of using the outline is that as the angle approaches
# 0 on a corner, the corner rounding seems to head towards infinity.
# spinning_3d_internal improves this by rotating two triangles independantly
class ScreensaverScene < Ray::Scene
  scene_name :screensaver

  def triangle(a, b, c)
    tri = Ray::Polygon.new
    tri.add_point(a, Ray::Color.green, Ray::Color.white)
    tri.add_point(b, Ray::Color.green, Ray::Color.white)
    tri.add_point(c, Ray::Color.green, Ray::Color.white)
    tri.filled   = false
    tri.outlined = true
    tri.outline_width = 5
    tri
  end
  
  def rotate_me(polygon, angle)
    polygon[1].pos = pp((Math.cos(angle) * -20), 20)
    polygon[2].pos = pp((Math.cos(angle) * 20), 20)
  end
    
  def percentage_position(x, y)
    [(Ray.screen_size.width * x) / 100, (Ray.screen_size.height * y) / 100]
  end
  alias :pp :percentage_position

  def setup
    @triangle = triangle(pp(0, -20), pp(-20, 20), pp(20,20))
    @triangle.pos = pp(50, 50)
  end
  
  def register
    angle = 0
    always do
      angle += 0.03
      rotate_me(@triangle, angle)
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
