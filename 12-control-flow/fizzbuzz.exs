# Exercise: ControlFlow-1
defmodule FizzBuzz do
  def upto(n), do: 1..n |> Enum.map(&fizzbuzz/1)

  defp fizzbuzz(n) do
    case {n, rem(n, 3), rem(n, 5)} do
      {_n, 0, 0} -> "FizzBuzz"
      {_n, 0, _} -> "Fizz"
      {_n, _, 0} -> "Buzz"
      {n, _, _} -> n
    end
  end
end
