require_relative 'line'
def read_starting_file
    @starting = []
    File.open("starting_scene.txt").each do |line|
        @starting.push Line.new(line.chomp) if not line.start_with? ">>"
    end
end

t = read_starting_file
t.each do |t|
    puts t
end