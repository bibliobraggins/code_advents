defmodule Day1_2023 do
  @data File.stream!("./data/2023/day_1.txt")

  @digits [0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39]

  def first_challenge() do
    Stream.map(@data, &parse_digits([], &1))
    |> Enum.into(
      [],
      &("#{List.first(&1)}#{List.last(&1)}"
        |> String.to_integer())
    )
    |> Enum.sum()
  end

  defp parse_digit(acc, char),
    do: acc ++ [char]

  @spec parse_digits(list(), binary()) :: list()
  defp parse_digits(acc, <<"">>), do: acc

  defp parse_digits(acc, <<symbol::8, tail::binary>>) do
    case Enum.member?(@digits, symbol) do
      true ->
        parse_digit(acc, <<symbol::8>>)
        |> parse_digits(tail)

      false ->
        parse_digits(acc, tail)
    end
  end

  @test [
    "sevenfivesixzvpone8f1plj"
  ]

  def second_challenge() do
    Stream.map(@test, &parse_digits_and_names([], &1))
    |> Enum.into(
      [],
      &("#{List.first(&1)}#{List.last(&1)}"
        |> String.to_integer())
    )
  end

  def parse_digits_and_names(acc, <<"">>), do: acc

  def parse_digits_and_names(acc, <<symbol, tail>>) do
    if Enum.member?(@digits, symbol) do
      parse_digit(acc, <<symbol>>)
      |> parse_digits_and_names(tail)
    else
      parse_digits_and_names(acc, tail)
    end
  end

  def parse_digits_and_names(acc, <<"zero", tail::binary>>),
    do: acc ++ ["0"] |> parse_digits_and_names(tail)
  def parse_digits_and_names(acc, <<"one", tail::binary>>),
    do: acc ++ ["1"] |> parse_digits_and_names(tail)
  def parse_digits_and_names(acc, <<"two", tail::binary>>),
    do: acc ++ ["2"] |> parse_digits_and_names(tail)
  def parse_digits_and_names(acc, <<"three", tail::binary>>),
    do: acc ++ ["3"] |> parse_digits_and_names(tail)
  def parse_digits_and_names(acc, <<"four", tail::binary>>),
    do: acc ++ ["4"] |> parse_digits_and_names(tail)
  def parse_digits_and_names(acc, <<"five", tail::binary>>),
    do: acc ++ ["5"] |> parse_digits_and_names(tail)
  def parse_digits_and_names(acc, <<"six", tail::binary>>),
    do: acc ++ ["6"] |> parse_digits_and_names(tail)
  def parse_digits_and_names(acc, <<"seven", tail::binary>>) do
      IO.puts "77777777777777777777777777777777777"
      acc ++ ["7"] |> parse_digits_and_names(tail)
  end
  def parse_digits_and_names(acc, <<"eight", tail::binary>>),
    do: acc ++ ["8"] |> parse_digits_and_names(tail)
  def parse_digits_and_names(acc, <<"nine", tail::binary>>),
    do: acc ++ ["9"] |> parse_digits_and_names(tail)

  def parse_digits_and_names(acc, <<_::8, tail::binary>>) do
    IO.puts "nilnilnilnilnil?"
    parse_digits_and_names(acc, tail)
end

end
