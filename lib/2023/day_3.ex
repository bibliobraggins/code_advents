defmodule Day3_2023 do

  @data File.read!("./data/2023/day_3.txt")

  @test """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """


  @intermediate_test """
  .........398.............551.....................452..................712.996.................646.40...1.....875..958.553...................
  ..................................661..-844......*.../781...835..#163....*.......698.239.........*.....*.............*............*57.......
  .....................&...............*......+..139..................................*.........-.......282......................301..........
  ........518..........918..-....472..172....776......207............38........................860..............274..945.....162..............
  ........@..........#.....845..*........................*.............*....896...+.....153................@......*...*.......#.........441...
  ..................740.21.....303...744.........190......173.395...729...-....&..925....@..5..............172...566..193...........#.........
  """

  def t2 do
    data = @data|>init_data()

    Enum.into(data, [], fn {row, y} ->
      {numbers_in_region(data, y)|>filter_region(row), y}
    end)
    |> Enum.filter(fn {cap, _} -> cap != [] end)
    |> Enum.into([], fn {captures, y} ->
      Enum.map(captures, fn {capture, x} ->
        {capture, {x, y}}
      end)
      |> Enum.group_by(fn {_capture, gear_y} -> gear_y end)
      |> Enum.map(fn {{gear, y}, captures} ->
        {(Enum.map(captures, fn {capture, _} -> capture end)|>List.flatten()), {gear, y}}
      end)
    end)
    |> List.flatten()
    |> Enum.filter(fn {captures, position} -> length(captures) == 2 end)
    |> Enum.map(fn {[f,r], _} -> f*r end)


  end

  def numbers_in_region(data, y) do
    Enum.into(safe_range(data, y), [], fn i ->
      Enum.at(data, i)
      |>parse_row()
      |> Enum.map(fn {cap, xF, xL} ->
        {cap, xF..xL}
      end)
    end)
  end

  def filter_region(numbers_in_region, row) do
    for x <- seek_gears(row), numbers <- numbers_in_region do
      {
        Enum.filter(numbers, fn {_number, range} ->
          (
            Enum.member?(range, x - 1) ||
            Enum.member?(range, x) ||
            Enum.member?(range, x + 1)
          )
        end)
        |> Enum.map(fn {number, _} -> String.to_integer(number) end),
        x
      }
    end
    |> Enum.filter(fn {cap, _} -> cap != [] end)

  end

  def init_data(raw_str) do
    raw_str
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.filter(fn {row, _} -> row != "" end)
  end

  @special_chars ["-", "*", "/", "#", "&", "+", "@", "=", "$", "%"]

  @spec seek_gears(binary()) :: [any()]
  def seek_gears(row),
    do: do_seek_gears(row, 0, []) |> Enum.reverse()

  defp do_seek_gears(<<""::utf8>>, _, acc), do: acc

  defp do_seek_gears(<<42::utf8, rest::binary>>, index, acc),
    do: do_seek_gears(rest, index + 1, [index] ++ acc)

  defp do_seek_gears(<<_::utf8, rest::binary>>, index, acc),
    do: do_seek_gears(rest, index + 1, acc)

  def c2 do
    data = @test |> String.split("\n", trim: true)

    meta =
      Enum.with_index(data)
      |> Enum.into([], fn {line, y} ->
        {line |> seek_gears(), y}
      end)
      |> Enum.filter(fn {x_list, _y} ->
        x_list != []
      end)

    Enum.into(meta, [], fn {gears, y} ->
      captures =
        filter_y(data, y)
        |> filter_x(gears)
        |> Enum.into([], fn {gear, {capture, _, _}} -> {gear, String.to_integer(capture)} end)
        |> Enum.group_by(fn {gear, _capture} -> gear end, fn {_gear, capture} -> capture end)
        |> Enum.map(fn {gear, captures} -> {gear, captures} end)

      captures
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp filter_x(scans, gears) do
    for(gear <- gears, scan <- scans, do: {gear, scan})
    |> Enum.filter(fn {gear, {_, xF, xL}} ->
      Enum.member?(xF..xL, gear - 1) ||
        Enum.member?(xF..xL, gear) ||
        Enum.member?(xF..xL, gear + 1)
    end)
  end

  defp filter_y(data, i) do
    Enum.into(safe_range(data, i), [], fn i -> Enum.at(data, i) |> parse_row(i) end)
    |> Enum.filter(fn r -> r != [] end)
    |> List.flatten()
  end

  defp safe_range(data, i) do
    case i do
      0 ->
        i..(i + 1)

      i when i < length(data) - 1 ->
        (i - 1)..(i + 1)

      i when i == length(data) - 1 ->
        (i - 1)..(i)
    end
  end

  def parse_row(row, i), do: parse_row({row, i})
  @spec parse_row({binary(), any()}) :: [{bitstring(), non_neg_integer(), integer()}]
  def parse_row({row, _i}) do
    do_parse_row(row, 0, "", 0)
  end

  defp do_parse_row("", _index, _digits, _start_index), do: []

  defp do_parse_row(<<digit::utf8, rest::binary>>, index, "", _start_index) when digit in ?0..?9,
    do: do_parse_row(rest, index + 1, <<digit::utf8>>, index)

  defp do_parse_row(<<digit::utf8, rest::binary>>, index, digits, start_index)
       when digit in ?0..?9,
       do: do_parse_row(rest, index + 1, digits <> <<digit::utf8>>, start_index)

  defp do_parse_row(<<_::utf8, rest::binary>>, index, "", _start_index),
    do: do_parse_row(rest, index + 1, "", index + 1)

  defp do_parse_row(<<_::utf8, rest::binary>>, index, digits, start_index),
    do: [{digits, start_index, index - 1} | do_parse_row(rest, index + 1, "", index + 1)]

  def c1 do
    Stream.with_index(@data)
    |> Enum.into([], &parse_row/1)
    |> scan1()
  end

  def scan1(capture_lists) do
    data = @data |> Enum.into([], &String.codepoints/1)

    capture_lists
    |> Enum.with_index()
    |> Enum.filter(fn {capture_list, _y} -> capture_list != [] end)
    |> Enum.map(fn {capture_list, y} ->
      y_range = safe_range(data, y)

      capture_list
      |> Enum.filter(fn {_capture, x_first, x_last} ->
        x_first = if x_first == 0, do: 0, else: x_first - 1
        x_last = if x_last == length(Enum.at(data, y)), do: x_last, else: x_last + 1

        x = Range.new(x_first, x_last)

        region =
          Enum.slice(data, y_range)
          |> Enum.map(fn r -> Enum.slice(r, x) end)
          |> List.flatten()

        Enum.any?(region, fn char -> Enum.member?(@special_chars, char) end)
      end)
    end)
    |> List.flatten()
    |> Enum.into([], fn {capture, _, _} -> String.to_integer(capture) end)
    |> Enum.sum()
  end
end
