require "gosu"
require_relative 'player'
require_relative 'enemy'
require_relative 'enemy1'
require_relative 'back_up'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'boom'
require_relative 'star'
require_relative 'credit'

class SectorFive < Gosu::Window
    WIDTH = 1000
    HEIGHT = 700
    ENEMY_FREQUENCY = 0.03
    BOOM_FREQUENCY = ENEMY_FREQUENCY
    STAR_FREQUENCY = 0.1
    MAX_ENEMIES = 100
    EXPLOSION_VOLUME = 0.4
    SHOOTING_VOLUME = 0.1
    def initialize
        super(WIDTH, HEIGHT)
        self.caption = "Sector Five"
        # Adjust the background image to fit to the window
        @background_image = Gosu::Image.load_tiles("images/space.png", WIDTH, HEIGHT)
        # Initialize the scene
        @scene = :start
        # Initialize and start the starting music
        @start_music = Gosu::Song.new("musics/starting_sound.ogg")
        @start_music.play(true)
    end

    # Remove the mouse
    def needs_cursor?
        false
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
        @background_image[0].draw(0, 0, 0)
        # Initialize messages
        message_font = Gosu::Font.new(self, "font/FiraMono-Regular.otf", 25)
        title_font = Gosu::Font.new(70)
        instruction_bottom_font = Gosu::Font.new(40)
        message = "As Enemy Ships Attack Your Planet In Waves,"
        message_1 = "You've Been Assigned To Protect..."
        title = "Sector Five"
        instruction = "Move Your Ship"
        instruction_1 = "With The Left, Right" 
        instruction_2 = "And Up Arrow Keys"
        instruction_3 = "Shoot Enemy Ships"
        instruction_4 = "By Pressing The"
        instruction_5 = "Space Bar"
        instruction_bottom = "Press Space Bar To Start"
        # Initialize image
        player_image = Gosu::Image.new("images/player.png")
        enemy_image = Gosu::Image.new("images/enemy.png")
        enemy1_image = Gosu::Image.new("images/enemy1.png")
        # Draw starting screen
        color_yellow = Gosu::Color.argb(0xff_ffff00)
        message_font.draw_text(message,270,50,1,1,1,color_yellow)
        message_font.draw_text(message_1,320,80,1,1,1,color_yellow)
        title_font.draw_text(title,355,200,1,1,1,Gosu::Color::RED)
        instruction_bottom_font.draw_text(instruction_bottom,320,620,1,1,1,Gosu::Color::RED)
        message_font.draw_text(instruction,80,350,1,1,1,color_yellow)
        message_font.draw_text(instruction_3,720,350,1,1,1,color_yellow)
        player_image.draw(150-12,400-12,1)
        enemy_image.draw(800-16,400-16,1)
        enemy1_image.draw(842-16,400-16,1)
        message_font.draw_text(instruction_1,60,425,1,1,1,color_yellow)
        message_font.draw_text(instruction_2,63,455,1,1,1,color_yellow)
        message_font.draw_text(instruction_4,740,425,1,1,1,color_yellow)
        message_font.draw_text(instruction_5,770,455,1,1,1,color_yellow)
    end

    def draw_game
        # Draw background
        @background_image[0].draw(0, 0, 0)
        # Draw player's ship
        @player.draw
        # Draw every enemy
        @enemies.each do |enemy|
            enemy.draw
        end
        @enemies1.each do |enemy|
            enemy.draw
        end
        # Draw every bullet
        @bullets.each do |bullet|
            bullet.draw
        end
        # Draw every explosion
        @explosions.each do |explosion|
            explosion.draw
        end
        # Draw every bomb
        @booms.each do |boom|
            boom.draw
        end
        # Draw every ally
        @back_ups.each do |back_up|
            back_up.draw
        end
        # Draw every star
        @stars.each do |star|
            star.draw
        end
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
        if id == Gosu::KbSpace
            initialize_game
        end
    end

    def initialize_game
        # Adjust the background image to fit to the window
        @background_image = Gosu::Image.load_tiles("images/space.png", WIDTH, HEIGHT)
        
        @player = Player.new(self)
        @enemies = []
        @enemies1 = []
        @bullets = []
        @explosions = []

        @booms = []
        @boom_it = false

        @back_ups = []
        @need_back_up = false

        @stars = []

        # Update the scene
        @scene = :game

        @enemies_appeared = 0
        @enemies_destroyed = 0
        # Initialize and start the music in the game
        @game_music = Gosu::Song.new("musics/game_sound.ogg")
        @game_music.play(true)
        # Initialize the sound effects
        @shooting_sound = Gosu::Sample.new("musics/shooting.ogg")
        @explosion_sound = Gosu::Sample.new("musics/explosion.ogg")
        # Update the time of the game
        @start_time = Gosu.milliseconds
    end

    def update_game
        # MOVE PLAYER
        @player.turn_left if button_down?(Gosu::KbLeft)
        @player.turn_right if button_down?(Gosu::KbRight)

        @player.accelerate if button_down?(Gosu::KbUp)
        @player.move

        # ADD SPRITES
        # Add star
        if rand < STAR_FREQUENCY
            @stars.push Star.new(self)
        end
        # Add backups
        if @need_back_up
            i = 30
            while i < WIDTH    
                @back_ups.push BackUp.new(self, i)  
                i += 45
            end
            @need_back_up = false
        end
        # Add a new bomb
        if @boom_it
            if rand < BOOM_FREQUENCY
                @booms.push Boom.new(self)
            end
        end
        # Add a new enemy
        if rand < ENEMY_FREQUENCY
            @enemies.push Enemy.new(self)
            @enemies_appeared += 1
        end
        if rand < ENEMY_FREQUENCY / 4 and @enemies_appeared > 30
            @enemies1.push Enemy1.new(self)
            @enemies_appeared += 1
        end

        # MOVE SPRITES
        # Move every enemy
        @enemies.each do |enemy|
            enemy.move
        end
        @enemies1.each do |enemy|
            enemy.move
        end
        # Move every bullet
        @bullets.each do |bullet|
            bullet.move
        end
        # Move every ally
        @back_ups.each do |back_up|
            back_up.move
        end

        # COLLISION DETECTION
        # For enemy
        @enemies.each do |enemy|
            @bullets.each do |bullet|
                distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
                if distance < enemy.radius + bullet.radius
                    @enemies.delete enemy
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @enemies_destroyed += 1
                    @explosion_sound.play(EXPLOSION_VOLUME)
                end
            end
        end
        @enemies.each do |enemy|
            @booms.each do |boom|
                distance_1 = Gosu.distance(enemy.x, enemy.y, boom.x, boom.y)
                if distance_1 < enemy.radius + boom.radius
                    @enemies.delete enemy
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @enemies_destroyed += 1
                    @explosion_sound.play(EXPLOSION_VOLUME)
                end
            end
        end
        @enemies.each do |enemy|
            @back_ups.each do |back_up|
                distance_2 = Gosu.distance(enemy.x, enemy.y, back_up.x, back_up.y)
                if distance_2 < enemy.radius + back_up.radius
                    @enemies.delete enemy
                    @back_ups.delete back_up
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @explosions.push Explosion.new(self, back_up.x, back_up.y)
                    @enemies_destroyed += 1
                    @explosion_sound.play(EXPLOSION_VOLUME)
                end
            end
        end
        # For enemy 1
        @enemies1.each do |enemy|
            @bullets.each do |bullet|
                distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
                if distance < enemy.radius + bullet.radius
                    if enemy.is_got_shot
                        @enemies1.delete enemy
                        @bullets.delete bullet
                        @explosions.push Explosion.new(self, enemy.x, enemy.y)
                        @enemies_destroyed += 1
                        @explosion_sound.play(EXPLOSION_VOLUME)
                    else
                        enemy.got_shot
                        @bullets.delete bullet
                        @explosion_sound.play(EXPLOSION_VOLUME)
                    end
                end
            end
        end
        @enemies1.each do |enemy|
            @booms.each do |boom|
                distance_1 = Gosu.distance(enemy.x, enemy.y, boom.x, boom.y)
                if distance_1 < enemy.radius + boom.radius
                    if enemy.is_got_shot
                        @enemies1.delete enemy
                        @explosions.push Explosion.new(self, enemy.x, enemy.y)
                        @enemies_destroyed += 1
                        @explosion_sound.play(EXPLOSION_VOLUME)
                    else
                        enemy.got_shot
                        @explosion_sound.play(EXPLOSION_VOLUME)
                    end
                end
            end
        end
        @enemies1.each do |enemy|
            @back_ups.each do |back_up|
                distance_2 = Gosu.distance(enemy.x, enemy.y, back_up.x, back_up.y)
                if distance_2 < enemy.radius + back_up.radius
                    if enemy.is_got_shot    
                        @enemies1.delete enemy
                        @back_ups.delete back_up
                        @explosions.push Explosion.new(self, enemy.x, enemy.y)
                        @explosions.push Explosion.new(self, back_up.x, back_up.y)
                        @enemies_destroyed += 1
                        @explosion_sound.play(EXPLOSION_VOLUME)
                    else
                        enemy.got_shot
                        @back_ups.delete back_up
                        @explosions.push Explosion.new(self, back_up.x, back_up.y)
                        @explosion_sound.play(EXPLOSION_VOLUME)
                    end
                end
            end
        end        

        # CLEANING UP ARRAYS
        # The arrays should only have the objects that can be seen in the window
        # Delete explosions that stop drawing itself after its sixteen frames of images
        @explosions.each do |explosion|
            @explosions.delete explosion if explosion.finished
        end
        @bullets.each do |bullet|
            @bullets.delete bullet if not bullet.onscreen?
        end
        @enemies.each do |enemy|
            if enemy.y - enemy.radius > HEIGHT 
                @enemies.delete enemy
            end
        end
        @enemies1.each do |enemy|
            if enemy.y - enemy.radius > HEIGHT 
                @enemies.delete enemy 
            end
        end
        @booms.each do |boom|
            @booms.delete boom if boom.finished
        end
        @back_ups.each do |back_up|
            @back_ups.delete back_up if back_up.y + back_up.radius < 0
        end
        @stars.each do |star|
            @stars.delete star if star.finished
        end

        # CHECK ENDGAME CONDITIONS
        # When the number of enemies that has appeared exceeds the value of MAX_ENEMIES
        initialize_end(:count_reached) if @enemies_appeared > MAX_ENEMIES
        # When an enemy ship collides with the player
        @enemies.each do |enemy|
            distance_3 = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)
            initialize_end(:hit_by_enemy) if distance_3 < enemy.radius + @player.radius
        end
        @enemies1.each do |enemy|
            distance_3 = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)
            initialize_end(:hit_by_enemy) if distance_3 < enemy.radius + @player.radius
        end
        # When the player ship flies off the top of the screen
        initialize_end(:off_top) if @player.y + @player.radius < 0
    end

    def button_down_game(id)
        # Get one bullet per button press
        if id == Gosu::KbSpace
            @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
            @shooting_sound.play()
        end
        # Activate the bomb throwing status
        if id == Gosu::KbB
            @boom_it = true
        end
        # Deactivate the bomb throwing status
        if id == Gosu::KbS
            @boom_it = false
        end
        # Call for back up
        if id == Gosu::KbC
            @need_back_up = true
        end
        # Stop the game
        if id == Gosu::KbX and button_down?(Gosu::KbLeftControl)
            initialize_end(:count_reached)
        end
    end
    
    def initialize_end(fate)
        # Stop the clock
        @end_time = Gosu.milliseconds
        @played_time = (@end_time - @start_time) / 1000
        # Initialize messages to player
        case fate
        when :count_reached
            @message = "You made it! In #{@played_time} seconds, you destroy #{@enemies_destroyed} enemy ships"
            @message_1 = "out of #{@enemies_appeared}."
        when :hit_by_enemy
            @message = "You were struck by an enemy ship."
            @message_1 = "Before your ship was destroyed, "
            @message_1 += "you took out #{@enemies_destroyed} enemy ships in #{@played_time} seconds."
        when :off_top
            @message = "You got too close to the enemy mother ship."
            @message_1 = "Before your ship was destroyed, "
            @message_1 += "you took out #{@enemies_destroyed} enemy ships in #{@played_time} seconds."
        end
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
        @end_music = Gosu::Song.new("musics/ending_sound.ogg")
        @end_music.play(true)
    end

    def draw_end
        # Draw credits only within an invisible box on the screen using clip_to method
        # The method clip_to takes first two are the x and y position of the top-left corner of a rectangle, 
        # and the second two are the width and height of the rectangle.
        clip_to(150, 150, WIDTH, 400) do
            @credits.each do |credit|
                credit.draw
            end
        end	
        # Draw messages and lines
        draw_line(0,150,Gosu::Color::RED,WIDTH,150,Gosu::Color::RED)	
        @message_font.draw(@message,40,35,1,1,1,Gosu::Color::FUCHSIA)
        @message_font.draw(@message_1,40,85,1,1,1,Gosu::Color::FUCHSIA)
        draw_line(0,550,Gosu::Color::RED,WIDTH,550,Gosu::Color::RED)
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
        if id == Gosu::KbP
            initialize_game
        end
        if id == Gosu::KbQ
            close
        end
    end
end

window = SectorFive.new
window.show