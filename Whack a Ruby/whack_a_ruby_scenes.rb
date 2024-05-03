require "gosu"
require_relative "credit"
module ZOrder
    BACKGROUND, MIDDLE, TOP =* 0..2
end
class WhackARuby < Gosu::Window
    WIDTH = 1000
    HEIGHT = 700
    TIME = 20
    def initialize
        # Adjust the size of the screen
        super(WIDTH, HEIGHT)        
        self.caption = "Whack A Ruby!"
        # Adjust the background image to fit to the window
        @background_image = Gosu::Image.load_tiles("images/background.png",WIDTH,HEIGHT)
        # Initialize the scene
        @scene = :start
        # Initialize and start the starting music
        @start_music = Gosu::Song.new("musics/starting_sound.ogg")
        @start_music.play(true)
    end

    def draw
        case @scene
        when :start
            draw_start
        when :game
            draw_game
        when :end
            draw_end
        end
    end

    def draw_start
        # Draw background
        @background_image[0].draw(0,0,0)
        # Initialize messages
        message_font = Gosu::Font.new(25)
        title_font = Gosu::Font.new(HEIGHT / 10)
        instruction_bottom_font = Gosu::Font.new(40)
        title = "Whack A Ruby"
        instruction = "Move Your Hammer"
        instruction_1 = "With The Mouse"
        instruction_2 = "Whack The Ruby"
        instruction_3 = "By Left Click"
        instruction_bottom = "Press Space Bar To Start"
        # Draw starting screen
        color_yellow = Gosu::Color.argb(0xff_ffff00)
        title_font.draw_text(title,240,100,1,1,1,Gosu::Color::RED)
        instruction_bottom_font.draw_text(instruction_bottom,320,620,1,1,1,Gosu::Color::RED)
        message_font.draw_text(instruction,80,350,1,1,1,color_yellow)
        message_font.draw_text(instruction_2,720,350,1,1,1,color_yellow)
        message_font.draw_text(instruction_1,95,385,1,1,1,color_yellow)
        message_font.draw_text(instruction_3,740,385,1,1,1,color_yellow)
    end

    def draw_game
        # Draw background
        @background_image[0].draw(0,0,0)
        # Make x and y represent the center of the ruby 
        @image.draw(@x - @width / 2, @y - @height / 2, 1) if @visible > 0
        # Make x and y represent the center of the hammer
        @hammer_image.draw(mouse_x - @hammer_width / 2, mouse_y - @hammer_height / 2, 1)
        # Add color effect for every hit
        color = Gosu::Color::NONE if @hit == 0
        color = Gosu::Color::GREEN if @hit == 1
        color = Gosu::Color::RED if @hit == -1
        draw_quad(0,0,color,1000,0,color,1000,700,color,0,700,color)
        @hit = 0
        # Show time and scores
        @font.draw(@score.to_s, 950, 10, 2)
        @font.draw(@time_left.to_s, 500, 10, 2)
    end

    def update
        case @scene
        when :game
            update_game
        when :end
            update_end
        end
    end

    def button_down(id)
        case @scene
        # Transition from start scene to game scene
        when :start
            button_down_start(id)
        # Do the game when the buttons pressed
        when :game
            button_down_game(id)
        when :end
            button_down_end(id)
        end
    end

    def button_down_start(id)
        # Press Space to transition from start scene to game scene.
        initialize_game if id == Gosu::KbSpace
    end

    def initialize_game
        # Import ruby image to the game
        @image = Gosu::Image.new('images/ruby.png')
        # Initialize the ruby
        @width = 100
        @height = 100
        @x = rand(WIDTH - 2 * @width) + @width
        @y = rand(HEIGHT - 2 * @height) + @height
        @velocity_x = rand(6) + 8
        @velocity_y = rand(6) + 8
        @visible = 0
        # Import hammer image to the game
        @hammer_image = Gosu::Image.new("images/hammer.png")
        # Initialize the ruby
        @hammer_width = 100
        @hammer_height = 123
        @hit = 0
        # Show the scores
        @font = Gosu::Font.new(30)
        @score = 0
        # Update the scene
        @scene = :game
        # Initialize and start the music in the game
        @game_music = Gosu::Song.new("musics/game_sound.ogg")
        @game_music.play(true)
        # Initialize the sound effects
        @hammer_sound = Gosu::Sample.new("musics/hammer_sound.ogg")
        # Update the time of the game
        @start_time = Gosu.milliseconds
    end

    def update_game
        # MOVE SPRITES
        # Make the ruby move
        @x += @velocity_x
        @y += @velocity_y  
        # Make the ruby bounce off the edges
        @velocity_x *= -1 if @x - @width / 2 < 0 or @x + @width / 2 > WIDTH
        @velocity_y *= -1 if @y - @height / 2 < 0 or @y + @height / 2 > HEIGHT
        @visible -= 1
        @visible = 30 if @visible < -45
        # CHECK ENDGAME CONDITION
        # Count down
        @time_left = TIME - ((Gosu.milliseconds - @start_time) / 1000)
        # When the time runs out
        initialize_end if @time_left == 0
    end

    def button_down_game(id)
        if id == Gosu::MsLeft
            @hammer_sound.play(2)
            if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 and @visible >= 0
                @hit = 1
                @score += 5
            else
                @hit = -1
                @score -= 1
            end            
        end
    end

    def initialize_end
        # Initialize messages to player
        @message = "Congratulations, you got #{@score} points."
        @bottom_message = "Press P to play again, or Q to quit."
        @message_font = Gosu::Font.new(30)
        # Initialize credits of the game
        @credits = []
        y = HEIGHT
        # Load credit from a text file
        File.open("credit.txt").each do |line|
            @credits.push(Credit.new(self, line.chomp, 150, y))
            y += 30
        end
        # Update the scene
        @scene = :end
        # Initialize and start the ending music
        @game_music = Gosu::Song.new("musics/ending_sound.ogg")
        @game_music.play(true)
    end

    def draw_end
        # Draw credits only within an invisible box on the screen using clip_to method
        # The method clip_to takes first two are the x and y position of the top-left corner of a rectangle, 
        # and the second two are the width and height of the rectangle.
        clip_to(150,150,WIDTH,400) do
            @credits.each do |credit|
                credit.draw
            end
        end
        # Draw messages and lines
        draw_line(0,150,Gosu::Color::RED,WIDTH,150,Gosu::Color::RED)
        draw_line(0,550,Gosu::Color::RED,WIDTH,550,Gosu::Color::RED)
        @message_font.draw(@message,40,35,1,1,1,Gosu::Color::FUCHSIA)
        @message_font.draw(@bottom_message,280,610,1,1,1,Gosu::Color::AQUA)
    end

    def update_end
        # Move the credit
        @credits.each do |credit|
            credit.move
        end
        # Reset the credit to their original positions 
        # and go again
        if @credits.last.y < 126
            @credits.each do |credit|
                credit.reset
            end
        end
    end

    def button_down_end(id)
        initialize_game if id == Gosu::KbP
        close if id == Gosu::KbQ
    end
end 

WhackARuby.new.show