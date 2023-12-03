defmodule Advent2023.Day2 do
  @data File.stream!("./data/2023/day_2.txt")


  @test ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\n"]
  def test do
    @test
    |> Stream.into([], & parse &1)
    |> Stream.run()
  end

  def parse(<<"Game "<><<game::8>> <>": ", tail::binary>>) do
    String.split(tail, ";")
    |> parse_sets()
  end

  def parse_sets([head|tail]) do
    Enum.into()
  end


  def c1() do
    @data
    |> Stream.into([], & IO.inspect &1)
    |> Stream.run()
  end

end
