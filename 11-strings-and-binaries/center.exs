# Exercise: StringsAndBinaries-5
defmodule Center do
  def center([]), do: []

  def center(strings = [_ | _]) do
    # Cache string lengths while calculating max length.
    {strings_and_lengths, max_length} =
      Enum.map_reduce(strings, 0, fn string, max_length ->
        length = String.length(string)
        {{string, length}, max(max_length, length)}
      end)

    Enum.map(strings_and_lengths, fn {string, length} ->
      padded_length = length + Integer.floor_div(max_length - length, 2)
      String.pad_leading(string, padded_length)
    end)
  end

  def print_centered(strings) do
    strings
    |> center()
    |> Enum.each(&IO.puts/1)
  end
end
