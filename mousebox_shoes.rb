require 'rubygems'
require 'ray'

Ray.game "Test" do
  register { add_hook :quit, method(:exit!) }

  scene :square do
    @rect = Ray::Polygon.rectangle([-10, -10, 20, 20], Ray::Color.red)

    on :mouse_motion do |pos|
      @rect.pos = pos
    end

    render do |win|
      win.draw @rect
    end
  end

  scenes << :square
end
