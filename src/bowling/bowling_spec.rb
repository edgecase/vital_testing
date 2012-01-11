require 'rspec/given'

class Bowling
  attr_reader :score

  def initialize
    @rolls = []
  end

  def roll(pins)
    @rolls << pins
  end

  def score
    rolls = @rolls
    result = 0
    index = 0
    10.times do
      if @rolls[index] == 10
        result += @rolls[index] + @rolls[index+1] + @rolls[index+2]
        index += 1
      elsif @rolls[index] + @rolls[index+1] == 10
        result += @rolls[index] + @rolls[index+1] + @rolls[index+2]
        index += 2
      else
        result += @rolls[index] + @rolls[index+1]
        index += 2
      end
    end
    result
  end
end

describe Bowling do
  Given(:game) { Bowling.new }

  describe "#roll" do
    Then {
      lambda { game.roll(0) }.should_not raise_error
    }
  end

  Given(:score) {
    throws.each do |pins| game.roll(pins) end
    game.score
  }

  context "with all gutter balls" do
    Given(:throws) { [0] * 20 }
    Then { score.should == 0 }
  end

  context "with different pins" do
    Given(:throws) { [1, 2, 3, 4] * 5 }
    Then { score.should == (1+2+3+4) * 5 }
  end

  context "with a spare followed by a 3" do
    Given(:throws) { [4, 6, 3] + [0] * 17 }
    Then { score.should == 16 }
  end

  context "with a strike followed by a frame of 8" do
    Given(:throws) { [10, 3, 5] + [0] * 17 }
    Then { score.should == (10+3+5) + (3+5) }
  end

  context "a perfect game" do
    Given(:throws) { [10] * 12 }
    Then { score.should == 300 }
  end
end
