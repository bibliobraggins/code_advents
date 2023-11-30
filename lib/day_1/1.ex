defmodule Day1 do

  @data File.read!(File.cwd! <> "/lib/day_1/data.txt")

  def total() do
    loop(@data)
  end

  def seek_idx(i) do
    Stream.scan(
      {@data, 0, 0},
      fn {<<byte::size(8), rest::binary>>, counter, position} ->
        {rest, {byte * 2, tally(counter, byte), position}}
      end)
      |> Enum.find(fn {counter, position} -> counter end)
  end

  defp loop(counter \\ 0, binary)
  defp loop(counter, <<>>), do: counter
  defp loop(counter, <<byte::8, rest::binary>>),
    do: tally(counter, <<byte>>) |> loop(rest)

  defp tally(counter, <<40>>) do
    counter + 1
  end
  defp tally(counter, <<41>>) do
    counter - 1
  end

end
