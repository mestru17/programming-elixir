# Exercise: StringsAndBinaries-6
defmodule Capitalize do
  def sentences(string) when is_binary(string) do
    string
    |> String.split(". ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(". ")
  end
end
