# Exercise: StringsAndBinaries-2
defmodule Anagram do
  def anagram?(word1, word2), do: Enum.sort(word1) == Enum.sort(word2)
end
