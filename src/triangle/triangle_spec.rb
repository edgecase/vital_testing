require 'rspec/given'

class TriangleClassifier
  def classify(a,b,c)
    a, b, c = [a,b,c].sort
    fail ArgumentError.new("Invalid Triangle") if a+b <= c
    number_of_unique_sides = [a,b,c].uniq.size
    [:equilateral, :isosceles, :scalene][number_of_unique_sides-1]
  end
end

module RSpec::Matchers
  matcher :be_a_bad_triangle do |expected|
    match do |sides|
      begin
        TriangleClassifier.new.classify(*sides)
        false
      rescue ArgumentError => ex
        true
      end
    end
    # failure_message_for_should do |expected| ... end
    # failure_message_for_should_not do |expected| ... end
  end
end

describe TriangleClassifier do
  def classify(a,b,c)
    TriangleClassifier.new.classify(a,b,c)
  end

  context "with equilateral triangles" do
    Then { classify(3,3,3).should == :equilateral }
  end

  context "with isosceles triangles" do
    it "returns :isosceles" do
      classify(2,3,3).should == :isosceles
      classify(3,2,3).should == :isosceles
      classify(3,3,2).should == :isosceles
    end
  end

  context "with isosceles triangles" do
    specify { classify(2,3,3).should == :isosceles }
    specify { classify(3,2,3).should == :isosceles }
    specify { classify(3,3,2).should == :isosceles }
  end

  context "with scalene triangles" do
    Then { classify(3,4,5).should == :scalene }
  end

  context "with non-triangles" do
    Then {
      lambda {
        classify(2,2,4)
      }.should raise_error(ArgumentError)
    }
  end

  context "with zeros for sides" do
    Then {
      lambda {
        classify(3,3,0)
      }.should raise_error(ArgumentError)
    }
  end

  context "with negative sides" do
    Then {
      lambda {
        classify(3,3,-3)
      }.should raise_error(ArgumentError)
    }
  end

  context "with bad sides" do
    Then { [2,2,4].should be_a_bad_triangle }
    Then { [3,3,0].should be_a_bad_triangle }
    Then { [3,3,-3].should be_a_bad_triangle }
  end

end
