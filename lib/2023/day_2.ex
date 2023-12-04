defmodule Advent2023.Day2 do
  @data File.stream!("./data/2023/day_2.txt")

  defmodule Game do
    defstruct [
      :id,
      :sets
    ]
  end

  alias Advent2023.Day2.Game, as: Game

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
    @data
    |> Enum.map(&parse/1)
    |> Enum.filter(fn game ->
      Enum.all?(game.sets, fn set ->
        Enum.all?(set, fn {color, value} ->
          value <= @constraints[color]
        end)
      end)
     end)
     |> Enum.into([], & &1.id)
     |> Enum.sum()
  end

  @test [
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
  ]
  @colors [:red, :green, :blue]
  def c2 do
    games = (@data |> Enum.into([], &parse/1))


    for [{_, v1},{_, v2},{_, v3}] <- Enum.into(games, [], &min_cubes/1) do
      v1*v2*v3
    end
    |> Enum.sum()

  end

  def min_cubes(%Game{id: _id, sets: sets}) do
    s = List.flatten(sets)


    Enum.reduce(s, [], fn {key, value}, acc ->
      Keyword.update(acc, key, value, fn existing_value ->
        max(existing_value, value)
      end)
    end)
  end
end
