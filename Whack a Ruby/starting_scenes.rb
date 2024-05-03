require_relative 'line'
class StartingScene
    def initialize(window)
        @window = window
        read_starting_file("starting_scene.txt")
        @title_size = @window.height / 8
        @title_font = Gosu::Font.new(@title_size, :name => "fonts/501.ttf")
    end

    def read_starting_file()
        @starting = []
        File.open("starting_scene.txt").each do |line|
            @starting.push Line.new(line.chomp) if not line.start_with? ">>"
        end
    end