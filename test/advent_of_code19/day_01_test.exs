defmodule AdventOfCode19.Day01Test do
  use ExUnit.Case
  doctest AdventOfCode19

  import AdventOfCode19.Day01

  describe "--- Day 1: The Tyranny of the Rocket Equation - Part One ---"do
    test "matches examples" do
      assert fuel_required_simple(12) == 2
      assert fuel_required_simple(14) == 2
      assert fuel_required_simple(1969) == 654
      assert fuel_required_simple(100756) == 33583
    end

    @tag disabled: true
    test "calculates result" do
      sum = calculate_first()
      IO.inspect("Day 1 - first puzzle: #{sum}")
    end
  end

  describe "--- Day 1: The Tyranny of the Rocket Equation - Part Two ---"do
    test "matches examples" do
      assert fuel_required(14) == 2
      assert fuel_required(1969) == 966
      assert fuel_required(100756) == 50346
    end

    @tag disabled: true
    test "calculates result" do
      sum = calculate_second()
      IO.inspect("Day 1 - second puzzle: #{sum}")
    end
  end
end
