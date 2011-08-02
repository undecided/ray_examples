require 'rubygems'
require 'ray'

class SquareDroppingScene < Ray::Scene
  scene_name :main

  def setup
    @rect = Ray::Polygon.rectangle(
              [-10, -10, 20, 20],
              Ray::Color.red)
  end
  
  def register
    on :mouse_motion do |pos|
      @rect.pos = pos
    end
  end
  
  def render(win)
    win.draw @rect
  end
end

class Game < Ray::Game
  def initialize
    super "Awesome Game"

    SquareDroppingScene.bind(self)

    scenes << :main
  end
  
  def register
    add_hook :quit, method(:exit!)
  end
end

Game.new.run