# Exercise: StringsAndBinaries-1
defmodule Ascii do
  def ascii?(char) when char in ?\s..?~, do: true
  def ascii?(char) when is_integer(char), do: false
  def ascii?([]), do: false
  def ascii?(list = [_ | _]), do: Enum.all?(list, &ascii?/1)

  def ascii2?([]), do: false
  def ascii2?([char]) when char in ?\s..?~, do: true
  def ascii2?([char | tail]) when char in ?\s..?~, do: ascii2?(tail)
  def ascii2?([_ | _]), do: false
end
