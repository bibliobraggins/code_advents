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
    ".664.598..",
  ]

  @special_chars [".", "-", "*", "/", "#", "&", "+", "@", "=", "$", "%"]

  def test do
    Stream.with_index(@test)
    |> Enum.into([], &parse_row/1)
    |> scan()
  end

  def scan(captures) do
    data = @test|>Enum.into([], &String.codepoints/1)

    captures =
      Enum.with_index(captures)|>Enum.filter(fn {captures, _y} -> captures != [] end)


  end



  defp safe_slice(list, start, finish) do
    Enum.slice(list, max(0, start), max(0, finish - start + 1))
  end

  @spec parse_row({binary(), any()}) :: [{bitstring(), non_neg_integer(), integer()}]
  def parse_row({row, _i}) do
    do_parse_row(row, 0, "", 0)
  end

  defp do_parse_row("", _index, _digits, _start_index), do: []

  defp do_parse_row(<<digit::utf8, rest::binary>>, index, "", _start_index) when digit in ?0..?9,
    do: do_parse_row(rest, index + 1, <<digit::utf8>>, index)

  defp do_parse_row(<<digit::utf8, rest::binary>>, index, digits, start_index) when digit in ?0..?9,
    do: do_parse_row(rest, index + 1, digits <> <<digit::utf8>>, start_index)

  defp do_parse_row(<<_::utf8, rest::binary>>, index, "", _start_index),
    do: do_parse_row(rest, index + 1, "", index + 1)

  defp do_parse_row(<<_::utf8, rest::binary>>, index, digits, start_index),
    do: [{digits, start_index, index - 1} | do_parse_row(rest, index + 1, "", index + 1)]

end
