require 'gosu'

# To setup for layering images on top of each other
module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

class Spinner < Gosu::Window
    WIDTH = HEIGHT = 480
    BACKGROUND_COLOR = Gosu::Color.new(0xFFF1C40F)
    WIN_VOLUME = 1
    def initialize
        super WIDTH, HEIGHT
        self.caption = "Winner Winner Chiken Spinner"
        # To load game's images
        @chicken_image = Gosu::Image.new("images/chicken.png")
        @arrow_image = Gosu::Image.new("images/arrow.png")
        @win_image = Gosu::Image.new("images/win.png")
        @lose_image = Gosu::Image.new("images/lose.png")
        # To load game's sound effects
        @spinning_sound = Gosu::Song.new("musics/spinning.ogg")
        @winning_sound = Gosu::Sample.new("musics/win.ogg")
        @chicken_angle = 0
        @game_over = false
    end

    def update
        return if @game_over
        @chicken_angle = (@chicken_angle + 10) % 360
        @spinning_sound.play(true)
    end

    def draw
        # To draw the background
        draw_quad(0,0,BACKGROUND_COLOR,WIDTH,0,BACKGROUND_COLOR,WIDTH,HEIGHT,BACKGROUND_COLOR,0,HEIGHT,BACKGROUND_COLOR,ZOrder::BACKGROUND)
        # To rotate the image
        @chicken_image.draw_rot(240,240,ZOrder::MIDDLE,@chicken_angle)
        @arrow_image.draw(380,200,ZOrder::MIDDLE)
        # To draw the game's message
        if @game_over
            @win_image.draw(40, 125, ZOrder::TOP) if did_we_win?
            @lose_image.draw(20, 85, ZOrder::TOP) if not did_we_win?
        end
    end

    def button_down(id)
        if id == Gosu::KbSpace
            if not @game_over
                @game_over = true
                @spinning_sound.pause
                @winning_sound.play(WIN_VOLUME) if did_we_win?
            # To continue the game
            else
                @game_over = false
            end
        end
        close if id == Gosu::KbEscape
    end

    def did_we_win?
        return true if @chicken_angle > 265 and @chicken_angle < 335
    end
end

Spinner.new.show