defmodule MyList do
  def length!([]), do: 0
  def length!([_head | tail]), do: 1 + length!(tail)

  def square!([]), do: []
  def square!([head | tail]), do: [head * head | square!(tail)]

  def add_1!([]), do: []
  def add_1!([head | tail]), do: [head + 1 | add_1(tail)]

  def map!([], _func), do: []
  def map!([head | tail], func), do: [func.(head) | map!(tail, func)]

  def length(list), do: _length(list, 0)
  defp _length([], acc), do: acc
  defp _length([_head | tail], acc), do: _length(tail, acc + 1)

  def square(list), do: _square(list, [])
  defp _square([], acc), do: reverse(acc)
  defp _square([head | tail], acc), do: _square(tail, [head * head | acc])

  def add_1(list), do: _add_1(list, [])
  defp _add_1([], acc), do: reverse(acc)
  defp _add_1([head | tail], acc), do: _add_1(tail, [head + 1 | acc])

  def map(list, func), do: _map(list, func, [])
  defp _map([], _func, acc), do: reverse(acc)
  defp _map([head | tail], func, acc), do: _map(tail, func, [func.(head) | acc])

  def generate_numbers(n), do: _generate_numbers(n - 1, [])
  defp _generate_numbers(-1, acc), do: acc
  defp _generate_numbers(i, acc), do: _generate_numbers(i - 1, [i | acc])

  def reverse(list), do: _reverse(list, [])
  defp _reverse([], acc), do: acc
  defp _reverse([head | tail], acc), do: _reverse(tail, [head | acc])

  def filter!([], _pred), do: []

  def filter!([head | tail], pred) do
    if pred.(head) do
      [head | filter(tail, pred)]
    else
      filter(tail, pred)
    end
  end

  def filter(list, pred), do: _filter(list, pred, [])
  defp _filter([], _pred, acc), do: reverse(acc)

  defp _filter([head | tail], pred, acc) do
    if pred.(head) do
      _filter(tail, pred, [head | acc])
    else
      _filter(tail, pred, acc)
    end
  end

  def reduce!([elem], _func), do: elem
  def reduce!([head | tail], func), do: func.(head, reduce!(tail, func))

  # This module is just here to group all the functions implemented via fold.
  defmodule Fold do
    # In the stdlib they don't call it fold - its just reduce/3 while normal reduce is reduce/2
    def fold([], acc, _func), do: acc
    def fold([head | tail], acc, func), do: fold(tail, func.(head, acc), func)

    def reduce([head | tail], func), do: fold(tail, head, func)

    def length(list), do: fold(list, 0, fn _elem, acc -> acc + 1 end)

    def reverse(list), do: fold(list, [], fn elem, acc -> [elem | acc] end)

    def map(list, func) do
      list
      |> fold([], fn elem, acc -> [func.(elem) | acc] end)
      |> reverse()
    end

    def filter(list, pred) do
      list
      |> fold([], fn elem, acc -> if pred.(elem), do: [elem | acc], else: acc end)
      |> reverse()
    end

    def square(list), do: map(list, &(&1 * &1))

    def add_1(list), do: map(list, &(&1 + 1))

    def sum(list), do: reduce(list, &(&1 + &2))

    # Exercise: ListsAndRecursion-1
    def mapsum(list, func) do
      list
      |> map(func)
      |> sum()
    end

    # Exercise: ListsAndRecursion-2
    def max(list), do: reduce(list, &max/2)

    # Exercise: ListsAndRecursion-3
    def caesar(list, n), do: map(list, &wrap_range(&1 + n, ?a..?z))
    defp wrap_range(n, min..max), do: Integer.mod(n - min, max - min + 1) + min

    # Exercise: ListsAndRecursion-4
    def span(from, to), do: _span(from, to, [])
    defp _span(from, from, acc), do: [from | acc]
    defp _span(from, to, acc), do: _span(from, to - 1, [to | acc])
  end
end
