require 'rspec/given'

# pins [x,y] = x+y                      -- last frame
# pins [x,y,z] = x+y+z                  -- last frame
# pins (x:y:z:xs)
#    | x == 10 = 10+y+z + pins (y:z:xs) -- Strike
#    | x+y == 10 = 10+z + pins (z:xs)   -- Spare
#    | otherwise = x+y  + pins (z:xs)   -- open frame

def pins(args)
  pins_from_frame(1, args)
end

def pins_from_frame(frame, args)
  if args.size == 2 && frame == 10
    args[0] + args[1]
  elsif args.size == 3 && frame == 10
    args[0] + args[1] + args[2]
  else
    x, y, z, *rest = args
    if x == 10
      10 + y + z + pins_from_frame(frame+1, args[1,100])
    elsif x+y == 10
      10 + z + pins_from_frame(frame+1, args[2,100])
    else
      x + y + pins_from_frame(frame+1, args[2,100])
    end
  end
end

describe :pins do
  context "with a gutter game" do
    Given(:throws) { (1..20).map { 0 } }
    Then { pins(throws).should == 0 }
  end

  context "with a game of all 1s" do
    Given(:throws) { (1..20).map { 1 } }
    Then { pins(throws).should == 20 }
  end

  context "with a spare + 3" do
    Given(:throws) { [4, 6, 3] + (4..20).map { 0 } }
    Then { pins(throws).should == 16 }
  end

  context "with a strike + 8" do
    Given(:throws) { [10, 3, 5] + (4..20).map { 0 } }
    Then { pins(throws).should == (10+3+5) + (3+5) }
  end

  context "with a perfect game" do
    Given(:throws) { (1..12).map { 10 } }
    Then { pins(throws).should == 10 * 30 }
  end

  context "with a strike in the last frame" do
    Given(:throws) { (1..18).map { 0 } + [10, 1, 0] }
    Then { pins(throws).should == 10+1 }
  end

  context "with a strike in the next to last frame" do
    Given(:throws) { (1..16).map { 0 } + [10, 1, 0] }
    Then { pins(throws).should == (10+1) + 1 }
  end

end
