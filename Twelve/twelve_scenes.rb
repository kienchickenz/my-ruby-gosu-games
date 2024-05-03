require 'gosu'
require_relative 'game'
require_relative 'credit'
require_relative 'timing'
module ZOrder
	BACKGROUND, MIDDLE, TOP =* 0..2
end

class Twelve < Gosu::Window
	WIDTH = 640
	HEIGHT = 690
	EFFECT_VOLUME = 1
	def initialize
		super(WIDTH,HEIGHT)
		self.caption = 'Twelve'
		# Adjust the background image to fit to the window
		@background_image = Gosu::Image.load_tiles("images/background.png", WIDTH, HEIGHT)
		# Initialize the scene
		@scene = :start
		# Initialize and loop the starting music
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
		@background_image[0].draw(0, 0, 0)
		# Initialize messages
		message_font = Gosu::Font.new(20)
		title_font = Gosu::Font.new(60)
		instruction_bottom_font = Gosu::Font.new(30)
		title = "Twelve"
		instruction_bottom = "Press Space Bar To Start"
		instruction = "Move A Square" 
		instruction_1 = "With The Mouse"
		instruction_2 = ""
		###########################
		# Draw starting screen
		color_yellow = Gosu::Color.argb(0xff_ffff00)
		title_font.draw_text(title,230,100,1,1,1,Gosu::Color::RED)
		instruction_bottom_font.draw_text(instruction_bottom,170,575,1,1,1,Gosu::Color::RED)
	end

	def draw_game
		@game.draw
		# Draw the clock
		@time.draw
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
		# Do the game when the buttons are pressed    
		when :game
			button_down_game(id)
		# Do the end when the button is pressed 
		when :end
			button_down_end(id)
		end
	end
	def button_up(id)
		case @scene
		when :game
			button_up_game(id)
		end
	end

	def button_down_start(id)
		# Press Space to transition from start scene to game scene.
		if id == Gosu::KbSpace
			initialize_game
		end
	end

	def initialize_game
		@game = Game.new(self)
		# Update the scene
		@scene = :game
		# Initialize and loop the music in the game
		@game_music = Gosu::Song.new("musics/game_sound.ogg")
		@game_music.play(true)
		# Initialize the sound effects
		@legal_moving_sound = Gosu::Sample.new("musics/moving.ogg")
		@illegal_moving_sound = Gosu::Sample.new("musics/error.ogg")
		# Update the time
		@start_time = Gosu.milliseconds
		# Initialize the clock
		@time = Time.new(self)
	end

	def update_game
		# To know whether the game has ended
		@game.end_game
		# CHECK ENDGAME CONDITIONS
		initialize_end(:winning) if @game.winning
		initialize_end(:losing) if @game.losing
		# To keep track of the mouse cursor 
		@game.handle_mouse_move(mouse_x, mouse_y)
		@time.timing()
	end

	def button_down_game(id)
		@game.handle_mouse_down(mouse_x, mouse_y) if id == Gosu::MsLeft
		# Reset the game
		initialize_game if id == Gosu::KbR and button_down?(Gosu::KbLeftControl)
	end

	# To figure out which square the player’s mouse cursor
	# was in when the mouse button was released.
	def button_up_game(id)
		if id == Gosu::MsLeft
			@game.handle_mouse_up(mouse_x, mouse_y)
			# To play the sound effect for every move
			if @game.move_is_legal
				@legal_moving_sound.play(EFFECT_VOLUME)
			else
				@illegal_moving_sound.play(EFFECT_VOLUME)
			end
		end
	end

	def initialize_end(fate)
		# Update the time
		@end_time = Gosu.milliseconds
		@played_time = (@end_time - @start_time) / 1000 
		@played_minutes = @played_time / 60
		@played_seconds = @played_time - @played_minutes * 60
		# Initialize messages to player
		case fate
		when :winning
			@message = "You made it! You solved the game in #{@played_minutes} minutes"
			@message_1 = "and #{@played_seconds} seconds. Your score is #{@played_time}."
		when :losing
			@message = "Oops! You lost after #{@played_minutes} minutes"
			@message_1 = "and #{@played_seconds} seconds. Better luck next time."
		end
		@bottom_message = "Press P to play again, or Q to quit."
		@message_font = Gosu::Font.new(24)
		# Initialize credits of the game
		@credits = []
		y = HEIGHT
		# Load credit from a text file
		File.open("credit.txt").each do |line|
			@credits.push(Credit.new(self, line.chomp, 80, y))
			y += 30
		end
		# Update the scene
		@scene = :end
		# Initialize and loop the ending music
		@end_music = Gosu::Song.new("musics/ending_sound.ogg")
		@end_music.play(true)
	end

	def draw_end
		# Draw credits only within an invisible box on the screen using clip_to method
		# The method clip_to takes first two are the x and y position of the top-left corner of a rectangle, 
		# and the second two are the width and height of the rectangle.
		clip_to(80, 150, WIDTH, 400) do
			@credits.each do |credit|
				credit.draw
			end
		end
		# Draw messages and lines
		draw_line(0,150,Gosu::Color::RED,WIDTH,150,Gosu::Color::RED)
		draw_line(0,550,Gosu::Color::RED,WIDTH,550,Gosu::Color::RED)
		@message_font.draw(@message,40,35,1,1,1,Gosu::Color::FUCHSIA)
		@message_font.draw(@message_1,40,75,1,1,1,Gosu::Color::FUCHSIA)
		@message_font.draw(@bottom_message,140,590,1,1,1,Gosu::Color::AQUA)
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
			@time.reset
		end
		close if id == Gosu::KbQ
	end
end

window = Twelve.new
window.show