class TriangleClassifier
  def classify(a,b,c)
    if a == b && b ==
      :equilateral
    else
      :isosceles
    end
  end
end

describe TriangleClassifier do
  let(:tri) { TriangleClassifier.new }

  context 'with equilateral triangles' do
    it "returns :equilateral" do
      tri.classify(3,3,3).should == :equilateral
    end
  end

  context 'with isosceles triangles' do
    it "returns :isosceles" do
      tri.classify(2,3,3).should == :isosceles
      tri.classify(3,3,2).should == :isosceles
    end
  end
end
