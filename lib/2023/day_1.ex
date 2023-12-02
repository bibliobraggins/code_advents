defmodule Advent2023.Day1 do
  @data File.stream!("./data/2023/day_1.txt")

  @symbols [0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39]

  def c1() do
    Stream.map(@data, &parse_digits([], &1))
    |> Enum.into(
      [],
      &([List.first(&1), List.last(&1)]
        |> List.to_integer() )
      ) |> Enum.sum()
  end

  @spec parse_digits(list(), binary()) :: list()
  defp parse_digits(acc, <<"">>), do: acc

  defp parse_digits(acc, <<symbol::8, tail::binary>>) do
    case Enum.member?(@symbols, symbol) do
      true ->
        acc ++ [symbol]
        |> parse_digits(tail)

      false ->
        parse_digits(acc, tail)
    end
  end

  @test [
    "eightdgczsgkc5seventlsfd",
    "xdljsnqjctzmmxcgxctdxxg73four",
    "2shjqglxct5rctbmgvfvjfvrqsvdmthree",
    "three71onekbksz8",
    "ninesevenzrcxnnbvninetwoftsvg39",
    "twofour36",
    "oneightwofe890789478392701483921voneoneeight"
  ]
  def c2() do
    Stream.map(@data, &parse_data(&1))
    |> Enum.into([],
      &(
        "#{String.first(&1)}#{String.last(&1)}"
        |> String.to_integer()
      )
    ) |> Enum.sum()
  end

  def parse_data(line) when is_binary(line), do: parse_chunk(line)

  defp parse_chunk(<<>>), do: <<>>

  defp parse_chunk(<<symbol::8, tail::binary>>) when symbol in ?1..?9,
    do: <<symbol>> <> parse_chunk(tail)

  defp parse_chunk(<<111, 110, 101, tail::binary>>),
    do: <<0x31>> <> parse_chunk("e" <> tail)

  defp parse_chunk(<<116, 119, 111, tail::binary>>),
    do: <<0x32>> <> parse_chunk("o" <> tail)

  defp parse_chunk(<<116, 104, 114, 101, 101, tail::binary>>),
    do: <<0x33>> <> parse_chunk("e" <> tail)

  defp parse_chunk(<<102, 111, 117, 114, tail::binary>>),
    do: <<0x34>> <> parse_chunk("r" <> tail)

  defp parse_chunk(<<102, 105, 118, 101, tail::binary>>),
    do: <<0x35>> <> parse_chunk("e" <> tail)

  defp parse_chunk(<<115, 105, 120, tail::binary>>),
    do: <<0x36>> <> parse_chunk("x" <> tail)

  defp parse_chunk(<<115, 101, 118, 101, 110, tail::binary>>),
    do: <<0x37>> <> parse_chunk("n" <> tail)

  defp parse_chunk(<<101, 105, 103, 104, 116, tail::binary>>),
    do: <<0x38>> <> parse_chunk("t" <> tail)

  defp parse_chunk(<<110, 105, 110, 101, tail::binary>>),
    do: <<0x39>> <> parse_chunk("e" <> tail)

  defp parse_chunk(<<_::8, tail::binary>>),
    do: parse_chunk(tail)
end
