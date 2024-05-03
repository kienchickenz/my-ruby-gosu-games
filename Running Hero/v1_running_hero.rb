require 'gosu'
require_relative 'hero_v1'

# To setup for layering images on top of each other
module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

class RunningHero < Gosu::Window
    WIDTH = 960
    HEIGHT = 480
    def initialize
        super WIDTH, HEIGHT
        self.caption = "Running Hero"
        @background_image = Gosu::Image.new("images/starry_night.png")
        @hero = Hero.new(self)
    end

    def draw
        # To draw the background
        @background_image.draw(0,0)
        # To draw the hero
        @hero.draw
    end

    def update
        if Gosu::button_down?(Gosu::KbRight)
            @hero.run_right
            @hero.standing_side = :right
        elsif Gosu::button_down?(Gosu::KbLeft)
            @hero.run_left
            @hero.standing_side = :left
        else
            @hero.stand
        end
    end
end

RunningHero.new.show