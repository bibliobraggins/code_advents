defmodule Advent2023.Day3 do
  @data File.stream!("./data/2023/day_3.txt", [], :line)

  @test [
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664.598.."
  ]

  @special_chars ["-", "*", "/", "#", "&", "+", "@", "=", "$", "%"]

  def c2 do
    data =
      @test |> Enum.into([], & &1)

    meta =
      Enum.with_index(data)
      |> Enum.flat_map(fn {line, y} ->
        case String.split(line, "", trim: true) |> Enum.find_index(&(&1 == "*")) do
          nil -> []
          x -> [{x, y}]
        end
      end)

    Enum.into(meta, [], fn {x, y} ->
      row = Enum.at(data, y)

      y_range =
        case y do
          0 -> 0..1
          i when i < byte_size(row) -> (i - 1)..(i + 1)
          i when i == byte_size(row) -> (i - 1)..i
        end

      region = Enum.slice(data, y_range)

      Enum.map(region, fn row_slice ->
        row_slice
        |> String.codepoints()
        |> Enum.chunk_by(fn <<char::utf8>> -> char in ?0..?9 end)
        |> Enum.filter(fn chunk ->
          case List.first(chunk) do
            <<char::utf8>> -> char in ?0..?9
            _ -> false
          end
        end)
        |> Enum.map(&Enum.join/1)
      end)
      |> Enum.filter(fn matches -> length(matches) == 2 end)
      |> Enum.into([], fn [m1, m2] ->
        m1 = m1 |> String.to_integer()
        m2 = m2 |> String.to_integer()
        m1 * m2
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

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
      |> Enum.filter(fn {capture, x_first, x_last} ->
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

  defp safe_range(data, i) do
    case i do
      0 -> i..(i + 1)
      i when i < length(data) -> (i - 1)..(i + 1)
      i when i == length(data) -> (i - 1)..i
    end
  end

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
end
