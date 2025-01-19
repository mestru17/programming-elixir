defmodule Prime do
  # Exercise: ListsAndRecursion-4
  def span(from, to), do: _span(from, to, [])
  defp _span(from, from, acc), do: [from | acc]
  defp _span(from, to, acc), do: _span(from, to - 1, [to | acc])

  # Exercise: ListsAndRecursion-7
  def is_prime(n) when n <= 2 or rem(n, 2) == 0 do
    false
  end

  def is_prime(n) when n > 2 and rem(n, 2) != 0 do
    factors =
      for x <- span(2, n - 1), rem(n, x) == 0 do
        x
      end

    length(factors) == 0
  end

  def primes(n) when is_integer(n) and n <= 2 do
    []
  end

  def primes(n) when is_integer(n) and n > 2 do
    for x <- span(2, n), is_prime(x) do
      x
    end
  end
end
