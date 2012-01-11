require 'rspec/given'

class Game
  def initialize
    @rolls = []
  end

  def roll(pins)
    @rolls << pins
  end

  def score
    result = 0
    rewind_frame_pointer
    10.times do
      if strike?
        result += sum_of_next(3)
        advance_frame_by(1)
      elsif spare?
        result += sum_of_next(3)
        advance_frame_by(2)
      else
        result += sum_of_next(2)
        advance_frame_by(2)
      end
    end
    result
  end

  private

  def sum_of_next(nrolls)
    (0...nrolls).inject(0) { |sum, offset| sum + pins_at(offset) }
  end

  def pins_at(offset)
    (@rolls[@current_roll+offset] || 0)
  end

  def strike?
    sum_of_next(1) == 10
  end

  def spare?
    sum_of_next(2) == 10
  end

  def rewind_frame_pointer
    @current_roll = 0
  end

  def advance_frame_by(nrolls)
    @current_roll += nrolls
  end
end

describe Game do
  Given(:game) { Game.new }
  Given(:score) { game.score }

  context "a gutter game" do
    Given { 20.times { game.roll(0) } }
    Then { score.should == 0 }
  end

  context "all 1 pins" do
    Given { 20.times { game.roll(1) } }
    Then { score.should == 10*2 }
  end

  context 'one spare, followed by a 3 and then gutters' do
    Given {
      game.roll(4)
      game.roll(6)
      game.roll(3)
      17.times { game.roll(0) }
    }
    Then { score.should == (10+3) + 3 }
  end

  context 'one strike, followed by an frame of 8 and then gutters' do
    Given {
      game.roll(10)
      game.roll(3)
      game.roll(5)
      16.times { game.roll(0) }
    }
    Then { score.should == (10+3+5) + (3+5) }
  end

  context 'a perfect game' do
    Given { 12.times { game.roll(10) } }
    Then { score.should == 10*30 }
  end

  context "with a strike in the last frame" do
    Given {
      18.times { game.roll(0) }
      game.roll(10)
      game.roll(1)
      game.roll(0)
    }
    Then { score.should == 10+1 }
  end

  context "with a strike in the next to last frame" do
    Given {
      16.times { game.roll(0) }
      game.roll(10)
      game.roll(1)
      game.roll(0)
    }
    Then { score.should == (10+1) + 1 }
  end

end
