defmodule AdventOfCode19.Day03Test do
  use ExUnit.Case

  import AdventOfCode19.Day03

  doctest AdventOfCode19.Day03

  describe "--- Day 3: Crossed Wires - Part One ---" do
    test "matches examples" do
      assert closest_intersection("""
             R75,D30,R83,U83,L12,D49,R71,U7,L72
             U62,R66,U55,R34,D71,R55,D58,R83
             """) == 159

      assert closest_intersection("""
             R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
             U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
             """) == 135
    end

    @tag disabled: true
    # TODO: fixme!
    test "calculates result" do
      result = closest_intersection(input_data())
      IO.inspect("Day 3 - first puzzle: #{result}")
    end
  end
end
