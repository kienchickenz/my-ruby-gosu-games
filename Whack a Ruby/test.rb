require 'gosu'
require_relative 'line'
module ZOrder
    BACKGROUND, MIDDLE, TOP =* 0..2
end

class Test < Gosu::Window
    def initialize
        super 640, 540
        @ex = read_starting_file()
    end
    def read_starting_file()
        starting = []
        File.open("starting_scene.txt").each do |line|
            starting.push Line.new(self, line.chomp) if not line.start_with? ">>"
        end
    end

    def draw
        @ex.each do |example|
            example.draw_title if example.text[0] == "t"
            puts example.text if example.text[0] == "t"
        end
    end
    def update
        puts @ex.size
    end
end

Test.new.show