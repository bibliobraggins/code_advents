defmodule Admin2015.Day1 do
  @data File.read!(File.cwd!() <> "/data/2015/day1.txt")

  def total() do
    loop(@data)
  end

  @spec seek_nth_val(non_neg_integer(), integer()) :: non_neg_integer()
  def seek_nth_val(n, input) do
    {_data, _i, position} =
      Stream.iterate({@data, 0, 0}, &iter_bytes/1)
      |> Stream.filter(&match_floor(&1, input))
      |> Stream.drop(n - 1)
      |> Stream.take(1)
      |> Enum.find_value(& &1)

    position
  end

  defp iter_bytes({"", current_floor, position}), do: {"", current_floor, position}

  defp iter_bytes({<<symbol::8, rest::binary>>, current_floor, position}),
    do: {rest, tally(current_floor, <<symbol>>), position + 1}

  defp match_floor({_data, current_floor, _position}, i),
    do: current_floor == i

  defp tally(current_floor, <<40>>), do: current_floor + 1
  defp tally(current_floor, <<41>>), do: current_floor - 1

  defp loop(current_floor \\ 0, binary)
  defp loop(current_floor, <<>>), do: current_floor

  defp loop(current_floor, <<symbol::8, rest::binary>>),
    do: tally(current_floor, <<symbol::8>>) |> loop(rest)
end

defmodule Day1 do
end
