ex = ["tSector 5", "iMove Your Hammer"]

ex.each do |ex|
    puts ex[1,ex.size - 1] if ex[0] == "t"
end
