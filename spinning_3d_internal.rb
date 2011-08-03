require 'rubygems'
require 'ray'

class TriangleOutline < Ray::Polygon
  def initialize(a,b,c, fill, outline)
    super()
    self.add_point(a, outline, fill)
    self.add_point(b, outline, fill)
    self.add_point(c, outline, fill)
  end
end

class TorchwoodScene < Ray::Scene
  scene_name :torchwood

  def triangle(a, b, c, fill = Ray::Color.white, outline = Ray::Color.white)
    TriangleOutline.new a, b, c, outline, fill
  end
  
  def rotate_me(polygon, angle, max)
    polygon[1].pos = pp((Math.cos(angle) * -max), max)
    polygon[2].pos = pp((Math.cos(angle) * max), max)
  end
    
  def percentage_position(x, y)
    [(Ray.screen_size.width * x) / 100, (Ray.screen_size.height * y) / 100]
  end
  alias :pp :percentage_position

  def setup
    @triangle = triangle(pp(0, -20), pp(-20, 20), pp(20,20))
    @filler = triangle(pp(0, -19), pp(-19, 20), pp(19,19), Ray::Color.black)
    @triangle.pos = pp(50, 50)
    @filler.pos = pp(50, 50)
  end
  
  def register
    angle = 0
    always do
      angle += 0.03
      rotate_me(@triangle, angle, 20)
      rotate_me(@filler, angle, 19)
    end
  end
  
  def render(win)
    win.draw @triangle
    win.draw @filler
  end
end


class Game < Ray::Game
  def initialize
    super "Awesome Game", :fullscreen => true, :size => Ray.screen_size

    ScreensaverScene.bind(self)

    scenes << :torchwood
  end
  
  def register
    add_hook :key_press, method(:exit!)
  end
end

Game.new.run
