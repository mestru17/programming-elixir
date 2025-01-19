# Exercise: ModulesAndFunctions-4
defmodule Sum do
  def from_one_to(1), do: 1
  def from_one_to(n), do: n + from_one_to(n - 1)
end
