defmodule Advent2023.Day2 do
  @data File.stream!("./data/2023/day_2.txt")

  defmodule Game do
    defstruct [
      :id,
      :sets
    ]
  end

  def parse(game) do
    [game, sets] =
      String.trim(game)
      |> String.trim_leading("Game ")
      |> String.split(": ")

    %Game{
      id: game |> String.to_integer(),
      sets: parse_sets(sets)
    }
  end

  def parse_sets(sets) do
    String.split(sets, "; ")
    |> Enum.into([], &String.split(&1, ", "))
    |> Enum.into([], &parse_set(&1))
  end

  def parse_set(set) do
    set
    |> Enum.into(
      [],
      fn s ->
        [count, color] = String.split(s, " ")
        {String.to_existing_atom(color), String.to_integer(count)}
      end
    )
  end

  @constraints [red: 12, green: 13, blue: 14]
  def c1 do
    pipeline(@data)
  end

  def pipeline(data) do
    games = Enum.into(data, [], &parse/1)

    Enum.filter(games, fn game -> filter(game.sets) end)
    |> Enum.into([], fn game -> game.id end)
  end

  def filter(sets) do
    Enum.all?(sets, fn set ->
      Enum.all?(set, fn {color, value} -> value <= @constraints[color] end)
    end)
  end
end
