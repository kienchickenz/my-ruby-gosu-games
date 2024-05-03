# >>> Ruby version 2.5.1 <<<
require 'gosu'
require 'chipmunk' # a physics engine that provides several classes for creating objects
require_relative 'boulder'
require_relative 'platform'
require_relative 'moving_platform'
require_relative 'wall'
require_relative 'hero'
require_relative 'camera'

class Escape < Gosu::Window
    WIDTH = 800
    HEIGHT = 800
    DAMPING = 0.9
    GRAVITY = 400
    BOULDER_FREQUENCY = 0.1
    attr_reader :space
    def initialize
        super WIDTH, HEIGHT
        self.caption = "Escape"
        @game_over = false
        # To hold and update all the physic objects
        @space = CP::Space.new
        # To draw background image more than once for filling the space
        @background = Gosu::Image.new("images/background.png", tileable: true)
        # To determine how much things will slow down on their own
        @space.damping = DAMPING
        # To represent gravity, we use Cp::Vec2 object that point straight down
        # by adjusting its vertical part
        @space.gravity = CP::Vec2.new(0, GRAVITY)
        @boulders = []
        @platforms = make_platforms
        # To add walls and floor
        @floor = Wall.new(self, 800, 1610, 1600, 20)
        @left = Wall.new(self,-10, 800, 20, 1600)
        @right = Wall.new(self, 1610, 870, 20, 1460)
        # To add the hero
        @player = Hero.new(self, 70, 1500)
        @camera = Camera.new(self, 1600, 1600)
        @camera.center_on(@player, 400, 200)
        # To add the exit
        @sign = Gosu::Image.new("images/exit.png")
        @font = Gosu::Font.new(self, "font/RubberDucky.ttf", 40)
        @color = Gosu::Color.new(0xFF283747)
    end

    def make_platforms
        platforms = []
        platforms.push Platform.new(self,150,700)
        platforms.push Platform.new(self,320,650)
        platforms.push Platform.new(self,150,500)
        platforms.push Platform.new(self,470,550)
        platforms.push MovingPlatform.new(self,580,600,70,:vertical)
        platforms.push Platform.new(self,320,440)
        platforms.push Platform.new(self,600,150)
        platforms.push Platform.new(self,700,450)
        platforms.push Platform.new(self,580,300)
        platforms.push MovingPlatform.new(self,190,330,50,:vertical)
        platforms.push MovingPlatform.new(self,450,230,70,:horizontal)
        platforms.push Platform.new(self,750,140)
        platforms.push Platform.new(self,700,700)
        return platforms
    end

    # In the update() method, the physics engine will STEP forward in time.
    # While the update() method runs about sixty times per second,
    # the physics step forward in even smaller increments. 
    # When objects are moving quickly, they might overlap by a large amount in one sixtieth of a second.
    # By having the physics engine update ten times every update(), or six
    # hundred times per second, the physics will be more realistic. 
    def update 
        @camera.center_on(@player, 400, 200)
        if not @game_over
            # To make the physics engine update ten times every update()
            10.times do
                @space.step(1.0/600)
            end
            if rand < BOULDER_FREQUENCY
                @boulders.push Boulder.new(self, 200 + rand(1200), -20)
            end
            # To move the hero
            if button_down?(Gosu::KbRight)
                @player.move_right
            elsif button_down?(Gosu::KbLeft)
                @player.move_left
            else
                @player.stand
            end
            # To move the platform
            @platforms.each do |platform|
                platform.move if platform.respond_to?(:move)
            end
            # To see if the game is over
            if @player.end_game?
                @game_over = true
                @win_time = Gosu.milliseconds
            end
        end
    end

    def button_down(id)
        if id == Gosu::KbSpace
            @player.jump
        end
        if id == Gosu::KbQ
            close
        end
    end

    def draw
        @camera.view do 
            # To draw the background
            @background.draw(0,0,0)
            @sign.draw(1450, 30, 2)
            @player.draw
            @boulders.each do |boulder|
                boulder.draw
            end
            @platforms.each do |platform|
                platform.draw
            end
        end
        if @game_over == false
            @seconds = (Gosu.milliseconds / 1000).to_i
            @font.draw("#{@seconds}",10,20,3,1,1,@color)
        else
            @font.draw("#{@win_time/1000}",10,20,3,1,1,@color)
            @font.draw("Game over",200, 300, 3,2,2,@color)
        end
    end
end

window = Escape.new
window.show