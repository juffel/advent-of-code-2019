defmodule AdventOfCode19.Day02 do
  def get_intcode_result(list) do
    [result | _] = intcode(list)
    result
  end

  def intcode(list) do
    intcode(list, 0)
  end

  def intcode(list, index) do
    case Enum.at(list, index) do
      1 -> operation(list, index, &summarize_values_at/2) |> put_result_and_continue(list, index)
      2 -> operation(list, index, &multiply_values_at/2) |> put_result_and_continue(list, index)
      99 -> list
      unknown -> raise "unknown opcode #{unknown} at #{index} in #{list}"
    end
  end

  def operation(list, index, fun) do
    [_opcode, op1_index, op2_index, result_index] = slice_op(list, index)
    result = fun.(list, [op1_index, op2_index])

    {result_index, result}
  end

  defp put_result_and_continue({result_index, result}, list, current_index) do
    list
    |> List.replace_at(result_index, result)
    |> intcode(current_index + 4)
  end

  defp slice_op(list, index) do
    Enum.slice(list, index, 4)
  end

  defp summarize_values_at(list, indices) do
    Enum.map(indices, &Enum.at(list, &1)) |> Enum.sum()
  end

  defp multiply_values_at(list, indices) do
    Enum.map(indices, &Enum.at(list, &1)) |> Enum.reduce(&(&1 * &2))
  end

  def restored_input_data(noun \\ 12, verb \\ 2) do
    input_data()
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  def input_data() do
    [
      1,
      0,
      0,
      3,
      1,
      1,
      2,
      3,
      1,
      3,
      4,
      3,
      1,
      5,
      0,
      3,
      2,
      13,
      1,
      19,
      1,
      19,
      10,
      23,
      1,
      23,
      13,
      27,
      1,
      6,
      27,
      31,
      1,
      9,
      31,
      35,
      2,
      10,
      35,
      39,
      1,
      39,
      6,
      43,
      1,
      6,
      43,
      47,
      2,
      13,
      47,
      51,
      1,
      51,
      6,
      55,
      2,
      6,
      55,
      59,
      2,
      59,
      6,
      63,
      2,
      63,
      13,
      67,
      1,
      5,
      67,
      71,
      2,
      9,
      71,
      75,
      1,
      5,
      75,
      79,
      1,
      5,
      79,
      83,
      1,
      83,
      6,
      87,
      1,
      87,
      6,
      91,
      1,
      91,
      5,
      95,
      2,
      10,
      95,
      99,
      1,
      5,
      99,
      103,
      1,
      10,
      103,
      107,
      1,
      107,
      9,
      111,
      2,
      111,
      10,
      115,
      1,
      115,
      9,
      119,
      1,
      13,
      119,
      123,
      1,
      123,
      9,
      127,
      1,
      5,
      127,
      131,
      2,
      13,
      131,
      135,
      1,
      9,
      135,
      139,
      1,
      2,
      139,
      143,
      1,
      13,
      143,
      0,
      99,
      2,
      0,
      14,
      0
    ]
  end
end
