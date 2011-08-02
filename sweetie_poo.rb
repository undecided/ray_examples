require 'rubygems'
require 'ray'
require 'active_support/core_ext'

Ray.game "Test" do
  register { add_hook :quit, method(:exit!) }

  scene :square do
    @sound = music File.join(File.dirname(__FILE__), "sweetiepoo.ogg")
    
    @sound.pause
    @stopped = true
    
    # @music.pos    = [10, 20, 30]
    @text = text "Initializing...", :size => 30, :angle => 0, :at => [300, 200]
    
    @angle = 0
    @end_time = 6.minutes.from_now.to_datetime
    always do
      @angle += 0.05
      remaining = @end_time.seconds_since_midnight - DateTime.now.seconds_since_midnight
      @text.string = "#{remaining} seconds left"
      if remaining < 0 && @stopped
        @stopped = false
        @sound.play
      end
      @text.angle = @angle
    end
    
    render do |win|
      win.draw @text
    end
  end

  scenes << :square
end
