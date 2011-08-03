require 'rubygems'
require 'ray'

def file(name)
  File.join(File.dirname(__FILE__), name)
end


class Ship < Ray::Sprite
  attr_reader :control
  
  class << self
    include Enumerable
    
    def all
      @all ||= []
    end
    
    # Demeter - it's the law :P
    def each(*args, &blk)
      @all.each(*args, &blk)
    end
  end
  
  def initialize(walls)
    super(file('ship.png'))
    @walls = walls
    self.safe_teleport
    self.angle = rand(360)
  end
  
  def safe_teleport
    self.teleport
    self.teleport until self.colliding_ships.empty? && self.colliding_walls.empty?
  end
  
  def crash_and_burn!
    unless colliding_ships.empty?
      (colliding_ships + [self]).each { |dead_ship| dead_ship.dead!}
    end
    self.dead! if self.colliding_arena?
  end
  
  def dead!
    @dead = true
    self.image = Ray::Image.new file('crash.png')
  end
  
  def dead?
    @dead
  end
  
  def colliding_ships
    self.class.select {|ship| self != ship and self.collide? ship }
  end
  
  def colliding_walls
    @walls.select { |wall| self.to_rect.collide? wall.to_rect }
  end
  
  def colliding_arena?
    !colliding_walls.empty?
  end
  
  def teleport
    self.pos = [rand(600) + 100, rand(400) + 100]
  end
end


class ArenaScene < Ray::Scene
  scene_name :arena
  attr_accessor :players

  def setup
    @arena = Ray::Polygon.rectangle([0, 0, 700, 500], Ray::Color.yellow)
    @arena.pos = [50,50]
    walls = [[0,0,800,50], [0,0,50,600], [750,0,50,600], [0,550,800,50] ]
    3.times do
      Ship.all << Ship.new(walls)
    end
  end
  
  def register
    always do
      # Just for testing. Maybe put logic here?
      Ship.each do |ship|
        ship.pos += [rand(31) - 15, rand(31) - 15] unless ship.dead?
        ship.crash_and_burn!
      end
    end
  end
  
  def render(win)
    win.draw @arena
    Ship.each { |p| win.draw p }
  end
end

class Game < Ray::Game
  def initialize
    super "Rubot Wars", :size => [800, 600]

    ArenaScene.bind(self)

    scenes << :arena
  end
  
  def register
    add_hook :quit, method(:exit!)
  end
end

Game.new.run