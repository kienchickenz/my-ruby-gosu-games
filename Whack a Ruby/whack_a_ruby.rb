require "gosu"

class WhackARuby < Gosu::Window
    def initialize
        # Adjust the size of the screen
        super(1000, 700)        
        self.caption = "Whack A Ruby!"
        # Import ruby image to the game
        @image = Gosu::Image.new('ruby.png')
        
        @x = 500
        @y = 500
       
        @width = 200
        @height = 231
        
        @velocity_x = 10
        @velocity_y = 10

        @visible = 0

        # Import hammer image to the game
        @hammer_image = Gosu::Image.new("hammer.png")

        @hit = 0

        # Show the scores
        @font = Gosu::Font.new(30)
        @big_font = Gosu::Font.new(50)
        @score = 0

        @is_playing = true

        @start_time = 0

        # Initialize the sound effects
        @hammer_sound = Gosu::Sample.new("hammer_sound.ogg")
    end

    def update

        if @is_playing

            # Make the ruby move
            @x += @velocity_x
            @y += @velocity_y
            
            # Make the ruby bounce off the edges
            @velocity_x *= -1 if @x - @width / 2 < 0 or @x + @width / 2 > 1000
            @velocity_y *= -1 if @y - @height / 2 < 0 or @y + @height / 2 > 700

            # Hide the ruby
            @visible -= 1
            @visible = 30 if @visible < -10 && rand < 0.1

            # Count down 
            @time_left = 30 - ((Gosu.milliseconds - @start_time) / 1000)

            @is_playing = false if @time_left == 0
        end
    end

    def draw
        if @visible > 0
            # Make x and y represent the center of the ruby 
            @image.draw(@x - @width / 2, @y - @height / 2, 1)
        end
        # Make x and y represent the center of the hammer
        @hammer_image.draw(mouse_x - 216 / 2, mouse_y - 266 / 2, 1)
        # Add color effect for every hit
        if @hit == 0
            color = Gosu::Color::NONE
        elsif @hit == 1
            color = Gosu::Color::GREEN
        elsif @hit == -1
            color = Gosu::Color::RED
        end
        draw_quad(0, 0, color, 1000, 0, color, 1000, 700, color, 0, 700, color)
        @hit = 0
        # Show time and scores
        @font.draw(@score.to_s, 950, 10, 2)
        @font.draw(@time_left.to_s, 500, 10, 2)
        # Show game over message
        if not @is_playing
            @big_font.draw("Game over!", 380, 300, 2)
            @font.draw("Press the Space Bar to Play Again", 300, 350, 2)
            @visible = 10
        end
    end

    def button_down(id)
        # Play the game
        if @is_playing
            if id == Gosu::MsLeft
                @hammer_sound.play(1)
                if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
                    @hit = 1
                    @score += 5
                else
                    @hit = -1
                    @score -= 1
                end            
            end
        else       
            # Restart the game     
            if(id == Gosu::KbSpace)
                @is_playing = true
                @visible = -20
                @start_time = Gosu.milliseconds
                @score = 0
            end
        end
    end
end

window = WhackARuby.new
window.show