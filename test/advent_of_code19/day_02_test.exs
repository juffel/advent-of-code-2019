defmodule AdventOfCode19.Day02Test do
  use ExUnit.Case

  import AdventOfCode19.Day02

  describe "--- Day 2: 1202 Program Alarm - Part One ---" do
    test "matches examples" do
      assert intcode([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
      assert intcode([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
      assert intcode([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
      assert intcode([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end

    @tag disabled: true
    test "calculates result" do
      [result | _] = intcode(restored_input_data())
      IO.inspect("Day 2 - first puzzle: #{result}")
    end
  end

  describe "--- Day 2: 1202 Program Alarm - Part Two ---" do
    @tag disabled: true
    test "checks all possible input values in a structured fashion" do
      structured_test_inputs()
      |> List.flatten()
      |> Enum.map(fn {noun, verb} ->
        case get_intcode_result(restored_input_data(noun, verb)) do
          19_690_720 ->
            IO.inspect("found input combination {noun, verb}: {#{noun}, #{verb}}")
            IO.inspect("result is: #{100 * noun + verb}")

          _other_value ->
            nil
        end
      end)
    end

    @tag disabled: true
    test "checks some random input values until the solution is found" do
      random_test_inputs()
    end

    defp structured_test_inputs() do
      Enum.to_list(0..99)
      |> Enum.map(fn noun -> Enum.to_list(0..99) |> Enum.map(&{noun, &1}) end)
    end

    defp random_test_inputs() do
      noun = :rand.uniform(100) - 1
      verb = :rand.uniform(100) - 1

      case get_intcode_result(restored_input_data(noun, verb)) do
        19_690_720 ->
          IO.inspect("found input combination {noun, verb}: {#{noun}, #{verb}}")
          IO.inspect("result is: #{100 * noun + verb}")

        _ ->
          IO.write(".")
          random_test_inputs()
      end
    end
  end
end
