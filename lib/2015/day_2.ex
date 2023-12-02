defmodule Day2_2015 do
  @data "./data/2015/day2.txt" |> File.read!()

  def order() do
    @data
    |> String.split("\n")
    |> Enum.into([], &iter_bytes(&1))
  end

  def iter_bytes(bytes) do
    {bytes, 1, []}
    |> Stream.iterate(&iter_byte/1)
  end

  defp iter_byte({<<symbol::8, rest::binary>>, i, acc}),
    do: {rest, i + 1, acc ++ symbol}

  defp iter_byte({"", _, acc}), do: acc

  def surface_area(l, w, h) do
    2 * l * w + 2 * w * h + 2 * h * l
  end
end
