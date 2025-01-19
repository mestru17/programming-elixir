defmodule Weather do

  defmodule Lists do
    def test_data do
      [
        # timestamp, location_id, temperature, rainfall
        [1_366_225_622, 26, 15, 0.125],
        [1_366_225_622, 27, 15, 0.45],
        [1_366_225_622, 28, 21, 0.25],
        [1_366_225_622, 26, 19, 0.081],
        [1_366_225_622, 27, 17, 0.468],
        [1_366_225_622, 28, 15, 0.60],
        [1_366_225_622, 26, 22, 0.095],
        [1_366_225_622, 27, 21, 0.05],
        [1_366_225_622, 28, 24, 0.03],
        [1_366_225_622, 26, 17, 0.025]
      ]
    end

    def for_location([], _loc), do: []
    def for_location([head = [_, loc, _, _] | tail], loc), do: [head | for_location(tail, loc)]
    def for_location([_ | tail], loc), do: for_location(tail, loc)
  end

  defmodule Tuples do
    def test_data, do: Weather.Lists.test_data() |> Enum.map(&List.to_tuple/1)

    def for_location([], _loc), do: []

    def for_location([head = {_, loc, _, _} | tail], loc) do
      [head | for_location(tail, loc)]
    end

    def for_location([_ | tail], loc), do: for_location(tail, loc)
  end

  defmodule KwLists do
    def test_data do
      Weather.Lists.test_data()
      |> Enum.map(fn [time, loc, temp, rain] -> [time: time, loc: loc, temp: temp, rain: rain] end)
    end

    def for_location([], _loc), do: []

    def for_location([head = [time: _, loc: loc, temp: _, rain: _] | tail], loc) do
      [head | for_location(tail, loc)]
    end

    def for_location([_ | tail], loc), do: for_location(tail, loc)
  end

  defmodule Maps do
    def test_data() do
      Weather.Lists.test_data()
      |> Enum.map(fn [time, loc, temp, rain] -> %{time: time, loc: loc, temp: temp, rain: rain} end)
    end

    def for_location([], _loc), do: []

    def for_location([head = %{loc: loc} | tail], loc) do
      [head | for_location(tail, loc)]
    end

    def for_location([_ | tail], loc), do: for_location(tail, loc)
  end

  defmodule Structs do
    defmodule Measurement do
      defstruct time: 0, loc: 0, temp: 0, rain: 0
    end

    def test_data() do
      Weather.Lists.test_data()
      |> Enum.map(fn [time, loc, temp, rain] -> %Measurement{time: time, loc: loc, temp: temp, rain: rain} end)
    end

    def for_location([], _loc), do: []
    def for_location([head = %Measurement{loc: loc} | tail], loc) do
      [head | for_location(tail, loc)]
    end
    def for_location([_ | tail], loc), do: for_location(tail, loc)
  end
end
