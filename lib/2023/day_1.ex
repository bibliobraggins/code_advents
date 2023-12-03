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

  defp parse_chunk(<<symbol::8, tail::binary>>) when symbol in 0x31..0x39,
    do: <<symbol>> <> parse_chunk(tail)

  defp parse_chunk(<<111::8, 110::8, 101::8, tail::binary>>),
    do: <<0x31::8>> <> parse_chunk(<<101::8>> <> tail)

  defp parse_chunk(<<116::8, 119::8, 111::8, tail::binary>>),
    do: <<0x32::8>> <> parse_chunk(<<111::8>> <> tail)

  defp parse_chunk(<<116::8, 104::8, 114::8, 101::8, 101::8, tail::binary>>),
    do: <<0x33::8>> <> parse_chunk(<<101::8>> <> tail)

  defp parse_chunk(<<102::8, 111::8, 117::8, 114::8, tail::binary>>),
    do: <<0x34::8>> <> parse_chunk(<<114::8>> <> tail)

  defp parse_chunk(<<102::8, 105::8, 118::8, 101::8, tail::binary>>),
    do: <<0x35::8>> <> parse_chunk(<<101::8>> <> tail)

  defp parse_chunk(<<115::8, 105::8, 120::8, tail::binary>>),
    do: <<0x36::8>> <> parse_chunk(<<120::8>> <> tail)

  defp parse_chunk(<<115::8, 101::8, 118::8, 101::8, 110::8, tail::binary>>),
    do: <<0x37::8>> <> parse_chunk(<<110::8>> <> tail)

  defp parse_chunk(<<101::8, 105::8, 103::8, 104::8, 116::8, tail::binary>>),
    do: <<0x38::8>> <> parse_chunk(<<116::8>> <> tail)

  defp parse_chunk(<<110::8, 105::8, 110::8, 101::8, tail::binary>>),
    do: <<0x39::8>> <> parse_chunk(<<101::8>> <> tail)

  defp parse_chunk(<<_::8, tail::binary>>),
    do: parse_chunk(tail)
end
