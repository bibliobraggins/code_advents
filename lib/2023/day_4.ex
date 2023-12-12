defmodule Day4_2023 do
  @data File.read!("./data/2023/day_4.txt")|> String.trim("\n")|>String.split("\n")

  @example """
          Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
          Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
          Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
          Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
          Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
          Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
          """ |> String.trim("\n")|> String.split("\n")

  defmodule Card do
    defstruct [
      :id,
      :winning_cards,
      :presented_cards
    ]
  end

  alias Day4_2023.Card, as: Card

  defp init() do
    @example |> inspect()

    @data |> Enum.map(&(parse_round/1))
  end

  def c1 do
    init()
    |> Enum.into([], fn game ->
      Enum.reduce(game.presented_cards, 0, fn card, acc ->
        if Enum.member?(game.winning_cards, card) do
          if acc == 0 do
            acc + 1
          else
            acc * 2
          end
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  def parse_round(round) do
    [id, sets] =
      (String.trim_leading(round, "Card ")|> String.split(":")|> Enum.map(fn str -> String.trim(str) end))

    [winning, presented] =
      String.split(sets, "|", trim: true)
      |> Enum.map(fn chars ->
        String.split(chars, " ", trim: true)
        |> Enum.filter(fn symbol -> symbol != <<"">> end)
      end)

    %Card{
      id: id,
      winning_cards: winning,
      presented_cards: presented
    }
  end
end
