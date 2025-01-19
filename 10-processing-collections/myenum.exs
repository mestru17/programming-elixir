defmodule MyEnum do
  def reduce([], acc, _fun), do: acc
  def reduce([head | tail], acc, fun), do: reduce(tail, fun.(head, acc), fun)

  def reduce_while([], acc, _fun), do: acc

  def reduce_while([head | tail], acc, fun) do
    case fun.(head, acc) do
      {:cont, acc} -> reduce_while(tail, acc, fun)
      {:halt, acc} -> acc
    end
  end

  def reduce([head | tail], fun), do: reduce(tail, head, fun)

  def reverse(list), do: reduce(list, [], fn x, acc -> [x | acc] end)

  def map(list, fun), do: reduce(list, fn x, acc -> [fun.(x) | acc] end) |> reverse()

  def all_reduce?(list, fun), do: reduce(list, true, fn x, acc -> fun.(x) and acc end)

  def each_reduce(list, fun) do
    reduce(list, :ok, fn x, acc ->
      fun.(x)
      acc
    end)
  end

  def filter_reduce(list, fun) do
    reduce(list, [], fn x, acc ->
      if fun.(x) do
        [x | acc]
      else
        acc
      end
    end)
  end

  def split_reduce(list, count) when count >= 0 do
    {left, right, _counter} =
      reduce_while(list, {[], list, count}, fn
        _x, {acc, list, 0} -> {:halt, {acc, list, 0}}
        _x, {acc, [], counter} -> {:halt, {acc, [], counter}}
        x, {acc, [_head | tail], counter} -> {:cont, {[x | acc], tail, counter - 1}}
      end)

    {reverse(left), right}
  end

  def take_reduce(list, count) when count >= 0 do
    {acc, _counter} =
      reduce_while(list, {[], count}, fn
        _x, {acc, 0} -> {:halt, {acc, 0}}
        x, {acc, counter} -> {:cont, {[x | acc], counter - 1}}
      end)

    reverse(acc)
  end

  # Exercise: ListsAndRecursion-5
  def all?(list, fun), do: _all?(list, true, fun)
  defp _all?([], acc, _fun), do: acc
  defp _all?([head | tail], acc, fun), do: _all?(tail, fun.(head) and acc, fun)

  def each([], _fun), do: :ok

  def each([head | tail], fun) do
    fun.(head)
    each(tail, fun)
  end

  def filter(list, fun), do: _filter(list, [], fun)
  defp _filter([], acc, _fun), do: reverse(acc)

  defp _filter([head | tail], acc, fun) do
    if fun.(head) do
      _filter(tail, [head | acc], fun)
    else
      _filter(tail, acc, fun)
    end
  end

  def split(list, count), do: _split(list, count, [])
  defp _split([], _counter, acc), do: {reverse(acc), []}
  defp _split(list, 0, acc), do: {reverse(acc), list}
  defp _split([head | tail], counter, acc), do: _split(tail, counter - 1, [head | acc])

  def take(list, count) when count >= 0, do: _take(list, count, [])
  def take(list, count) when count < 0, do: _take_reverse(reverse(list), count, [])

  defp _take(_list, 0, acc), do: reverse(acc)
  defp _take([], _counter, acc), do: reverse(acc)
  defp _take([head | tail], counter, acc), do: _take(tail, counter - 1, [head | acc])

  defp _take_reverse(_list, 0, acc), do: reverse(acc)
  defp _take_reverse([], _counter, acc), do: reverse(acc)

  defp _take_reverse([head | tail], counter, acc) do
    _take_reverse(tail, counter + 1, [head | acc])
  end

  # Exercise: ListsAndRecursion-5
  def flatten(list) when is_list(list) do
    list
    |> flatten_acc([])
    |> reverse()
  end

  defp flatten_acc(list, acc) do
    reduce(list, acc, fn
      list, acc when is_list(list) -> flatten_acc(list, acc)
      x, acc -> [x | acc]
    end)
  end

  def flatten_recursive(list) do
    list
    |> flatten_recursive_acc([])
    |> reverse()
  end

  defp flatten_recursive_acc([], acc) do
    acc
  end

  defp flatten_recursive_acc([head | tail], acc) when is_list(head) do
    flatten_recursive_acc(tail, flatten_recursive_acc(head, acc))
  end

  defp flatten_recursive_acc([head | tail], acc) do
    flatten_recursive_acc(tail, [head | acc])
  end
end
