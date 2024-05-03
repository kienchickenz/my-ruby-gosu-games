require 'gosu'
require_relative 'game'

class Twelve < Gosu::Window
    WIDTH = HEIGHT = 640
    def initialize
        super(WIDTH,HEIGHT)
        self.caption = 'Twelve'
        @game = Game.new(self)
    end

    def draw
        @game.draw
    end

    def button_down(id)
        if id == Gosu::MsLeft
            @game.handle_mouse_down(mouse_x, mouse_y)
        end
        # To play again
        if id == Gosu::KbP and button_down?(Gosu::KbRightControl)
            @game = Game.new(self)
        end
    end

    # To figure out which square the player’s mouse cursor
    # was in when the mouse button was released.
    def button_up(id)
        if id == Gosu::MsLeft
            @game.handle_mouse_up(mouse_x, mouse_y)
        end
    end

    # To know where the mouse cursor is 
    # for highlighting squares.
    def update
        @game.handle_mouse_move(mouse_x, mouse_y)
    end
end

window = Twelve.new
window.show