# Exercise: ModulesAndFunctions-6
defmodule Chop do
  def guess(actual, range) do
    print_and_guess(actual, range, middle(range))
  end

  defp middle(a..b), do: div(a + b, 2)

  defp print_and_guess(actual, range, guess) do
    IO.puts("Is it #{guess}")
    guess(actual, range, guess)
  end

  defp guess(actual, _, actual), do: IO.puts(actual)

  defp guess(actual, a.._, guess) when guess > actual do
    new_range = a..guess
    print_and_guess(actual, new_range, middle(new_range))
  end

  defp guess(actual, _..b, guess) when guess < actual do
    new_range = guess..b
    print_and_guess(actual, new_range, middle(new_range))
  end
end
