require 'rspec/given'

class Solver
  def parse(string)
    @cells = string.
      gsub(/-/, '0').
      gsub(/[^0-9]/, '').
      split(//).
      map { |c| c.to_i }
  end

  def puzzle
    @cells.map { |c|
      (c.nonzero? || "-").to_s
    }.join('')
  end

  def solve
  end

  def solution
    @puzzle
  end

  def to_s
    puzzle.
      gsub(/(...)/, '\1 ').
      gsub(/(... ... ...) /, "\\1\n")
  end
end

describe Solver do
  context "can parse a puzzle" do
    Given(:solver) { Solver.new }
    Given(:puzzle) {
      "6-9923---" +
      "3-5--86-4" +
      "79146-8-3" +
      "8----243-" +
      "2-97465-8" +
      "-648----9" +
      "9-2-14387" +
      "1-63--9-2" +
      "4--2891-5"
    }
    Given(:solution) {
      "642923751" +
      "325178694" +
      "791465823" +
      "817592436" +
      "239746518" +
      "561831279" +
      "952614387" +
      "186357942" +
      "473289165"
    }
    When {
      solver.parse(puzzle)
      solver.solve
    }
    Then { solver.puzzle.should == puzzle }
    Then { pending "final solution"; solver.solution.should == solution }
    Then {
      solver.to_s.should ==
      "6-9 923 ---\n" +
      "3-5 --8 6-4\n" +
      "791 46- 8-3\n" +
      "8-- --2 43-\n" +
      "2-9 746 5-8\n" +
      "-64 8-- --9\n" +
      "9-2 -14 387\n" +
      "1-6 3-- 9-2\n" +
      "4-- 289 1-5\n"
    }
  end
end
