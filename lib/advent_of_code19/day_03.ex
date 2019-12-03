defmodule AdventOfCode19.Day03 do
  def closest_intersection(input_string) do
    paths = parse_input(input_string)

    empty_grid = initialize_empty_grid(paths)

    origin = length(empty_grid) / 2

    # FYI: print grid using inspect_grid()
    empty_grid
    |> put_paths(paths, origin)
    |> get_intersections()
    |> select_closest_intersection(origin)
  end

  defp select_closest_intersection(intersections, origin) do
    intersections
    |> Enum.map(fn intersection ->
      manhattan_distance(intersection, {origin, origin})
    end)
    |> Enum.min()
  end

  defp manhattan_distance({p1_x, p1_y}, {p2_x, p2_y}) do
    abs(p1_x - p2_x) + abs(p1_y - p2_y)
  end

  defp get_intersections(grid) do
    Enum.with_index(grid)
    |> Enum.map(fn {row, row_index} ->
      Enum.with_index(row)
      |> Enum.map(fn {cell, cell_index} ->
        if Enum.uniq(cell) |> length() > 1 do
          {row_index, cell_index}
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(fn value ->
      case value do
        {_row_index, _cell_index} -> true
        _ -> false
      end
    end)
  end

  defp put_paths(grid, paths, origin) do
    Enum.with_index(paths)
    |> Enum.reduce(grid, fn {path, path_index}, updated_grid ->
      put_path_by_origin(updated_grid, path, origin, path_index)
    end)
  end

  defp put_path_by_origin(grid, path, origin, label) do
    put_path(grid, {origin, origin}, path, label)
  end

  defp put_path(grid, _coords, [], _label), do: grid

  defp put_path(grid, coords, [command | path], label) do
    updated_grid = execute_command(grid, coords, command, label)
    put_path(updated_grid, updated_coords(coords, command), path, label)
  end

  defp execute_command(grid, coords, %{direction: direction, amount: amount}, label) do
    Enum.with_index(grid)
    |> Enum.map(fn {row, row_index} ->
      Enum.with_index(row)
      |> Enum.map(fn {cell, cell_index} ->
        if mark(direction, coords, cell_index, row_index, amount) do
          cell ++ [label]
        else
          cell
        end
      end)
    end)
  end

  defp updated_coords({coord_x, coord_y}, %{direction: direction, amount: amount}) do
    case direction do
      "U" -> {coord_x, coord_y - amount}
      "D" -> {coord_x, coord_y + amount}
      "L" -> {coord_x - amount, coord_y}
      "R" -> {coord_x + amount, coord_y}
    end
  end

  defp mark("U", {coord_x, coord_y}, cell_index, row_index, amount) do
    cell_index == coord_x && row_index <= coord_y && row_index > coord_y - amount
  end

  defp mark("D", {coord_x, coord_y}, cell_index, row_index, amount) do
    cell_index == coord_x && row_index > coord_y && row_index <= coord_y + amount
  end

  defp mark("L", {coord_x, coord_y}, cell_index, row_index, amount) do
    row_index == coord_y && cell_index <= coord_x && cell_index > coord_x - amount
  end

  defp mark("R", {coord_x, coord_y}, cell_index, row_index, amount) do
    row_index == coord_y && cell_index > coord_x && cell_index <= coord_x + amount
  end

  defp inspect_grid(grid) do
    grid
    |> Enum.each(fn row ->
      Enum.each(row, fn cell ->
        case cell do
          [] -> IO.write(".")
          [_label] -> IO.write("-")
          _value -> IO.write("@")
        end
      end)

      IO.write("\n")
    end)
  end

  # creates a quadratic matrix with dimensions of the maximum possible path sizes
  defp initialize_empty_grid(paths) do
    maximum =
      paths
      |> Enum.map(&get_path_maximum/1)
      |> Enum.max()

    1..(maximum * 2)
    |> Enum.to_list()
    |> Enum.map(fn _value ->
      Enum.to_list(1..(maximum * 2))
      |> Enum.map(fn _value -> [] end)
    end)
  end

  defp get_path_maximum(commands) do
    ["U", "R", "D", "L"]
    |> Enum.map(fn dir ->
      commands
      |> Enum.filter(fn command -> command[:direction] == dir end)
      |> Enum.map(fn command -> command[:amount] end)
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  defp parse_input(string) do
    string
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(",")
    |> Enum.map(&parse_command/1)
  end

  @doc """
  ## Examples
      iex> parse_command("R997")
      %{direction: "R", amount: 997}

      iex> parse_command("L49")
      %{direction: "L", amount: 49}
  """
  def parse_command(string) do
    # Regex.named_captures(~r/(?<direction>[A-Z])(?<amount>[0-9]*)/, string)
    # |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    %{"direction" => direction, "amount" => amount} =
      Regex.named_captures(~r/(?<direction>[A-Z])(?<amount>[0-9]*)/, string)

    %{direction: direction, amount: String.to_integer(amount)}
  end

  def input_data do
    """
    R997,D543,L529,D916,R855,D705,L159,U444,R234,U639,L178,D682,L836,U333,R571,D906,L583,U872,L733,U815,L484,D641,R649,U378,L26,U66,L659,D27,R4,U325,L264,D711,L837,D986,L38,U623,L830,D369,L469,D704,L302,U143,L771,U170,R237,U477,L251,D100,R561,D889,R857,D780,R258,D299,L975,D481,L692,D894,R847,D416,R670,D658,L537,U748,R468,D304,L263,D884,R806,D13,R288,U933,R4,U291,L809,D242,R669,D50,R106,D510,R409,U311,R101,D232,R370,D490,L762,D805,L981,D637,L987,U403,R965,U724,L404,D664,L687,U868,L808,D174,L363,D241,L54,D238,R444,U75,R683,U712,L759,D569,R349,D378,L576,U437,R137,D822,R21,D595,L602,U147,R959,U350,R964,U625,L718,U331,L252,D386,L251,U371,R973,D709,R915,D837,L7,U727,L501,D520,L626,U161,L287,D224,L821,U555,L312,U234,L335,D572,L113,U673,L615,D919,R925,U16,R211,U77,R630,U786,R850,D221,R939,U559,R887,U779,L222,D482,L252,D682,L904,U568,R317,D453,R689,D917,R845,U260,R69,U613,R528,D447,L791,D119,L268,U215,L806,U786,R465,D787,L792,D823,R526,D709,L362,D748,L518,U115,L898,U784,R893,U911,R98,U215,R828,D100,R153,U496,L938,D403,R886,D317,L849,D59,R156,D27,L64,D771,R956,U880,R313,D244,L483,D17,R72,U467,L475,D444,R554,D781,R524,D152,L771,U435,L622,D601,R733,D478,L686,D12,L525,D467,L302,D948,L966,U572,L303,U914,R54,D417,R635,D425,R640,D703,R17,D187,L195,U59,R166,D616,L557,U458,L743,D166,R328,D640,R908,D775,L151,D216,L964,D202,L534,D239,R998,U167,L604,D812,L527,U526,L640,U93,L733,D980,R607,D879,L593,D721,R454,U137,R683,D343,L38,D398,L81,U392,R821,U247,L361,D208,R763,D771,L515
    L1000,D189,L867,U824,L193,D12,R704,U83,R371,D858,L970,D56,R877,D448,R962,U239,R641,D198,L840,D413,R586,D920,R650,U919,R375,D540,L150,U995,R54,D200,R61,D974,R249,U893,R319,U930,R658,U680,R286,D186,R963,U553,L256,U629,L554,U576,R887,U595,R629,D680,L684,U556,L302,U348,R825,D252,L684,U705,L258,D72,R907,U702,L518,U440,R239,U258,R825,U27,L580,D613,R357,D468,R519,U833,L415,D822,L798,U904,R812,U76,R86,U252,R427,U637,L896,U147,L294,U381,R306,U423,L688,D336,R648,U677,L750,D218,L649,D360,R710,D64,R317,U232,R261,D167,L49,D138,L431,D505,L535,U294,L553,U969,L144,U227,R437,D397,R359,U848,L48,D992,R169,D580,L219,D525,R552,U546,R849,D722,R894,D735,L182,U570,R274,D349,R312,U430,R441,U183,R645,D308,L416,U333,L687,U202,L973,D736,R382,U260,L176,D207,R706,U52,L142,D746,L328,D413,R879,D429,L679,D695,L224,D462,R358,D124,L515,D629,L873,D759,L763,U28,R765,D426,L93,U927,L395,U243,L393,D488,L729,U100,R488,D83,R47,U92,L871,D410,R405,D993,R537,D10,L79,D218,L686,D563,L31,U885,L784,D462,L160,U345,R204,U275,R162,U164,R843,D578,R255,D456,L398,U470,L576,D973,L337,D971,R205,U264,R707,U975,L60,U270,R1,U808,R844,D884,L952,D435,L144,D374,R389,D741,R404,D398,R282,D807,L316,U136,L504,U720,R859,D925,L711,U343,L535,D978,R578,U636,L447,D298,R574,U590,L142,D802,L846,D617,L838,U362,R812,U295,L328,U162,L617,D857,L759,D251,L343,U394,R721,U320,R836,U726,L950,D612,R129,U549,L970,D87,L341,D269,L659,U550,R835,D318,L189,U278,R871,D62,R703,U807,L389,U824,R521,D175,L698,U313,L942,D810,L498,U18,R168,D111,R607
    """
  end
end
