defmodule Advent2023.Day3 do
  @data File.stream!("./data/2023/day_3.txt", [])

  def c1() do
    @data
    |> Stream.with_index()
    |> Enum.into([], & &1)
  end

end
