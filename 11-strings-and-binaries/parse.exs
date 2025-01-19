# Exercise: StringsAndBinaries-4
defmodule Parse do
  def number([?- | tail]), do: _number_digits(tail, 0) * -1
  def number([?+ | tail]), do: _number_digits(tail, 0)
  def number(str), do: _number_digits(str, 0)

  defp _number_digits([], value) do
    {value, []}
  end

  defp _number_digits([digit | tail], value) when digit in ?0..?9 do
    _number_digits(tail, value * 10 + digit - ?0)
  end

  defp _number_digits(str = [_ | _], value) do
    {value, str}
  end

  def skip_whitespace([]), do: []
  def skip_whitespace([?\s | tail]), do: skip_whitespace(tail)
  def skip_whitespace(str = [_ | _]), do: str

  def operator([?+ | tail]), do: {&(&1 + &2), tail}
  def operator([?- | tail]), do: {&(&1 - &2), tail}
  def operator([?* | tail]), do: {&(&1 * &2), tail}
  def operator([?/ | tail]), do: {&(&1 / &2), tail}
  def operator([non_op | _]), do: raise("Invalid operator '#{[non_op]}'")

  def calculate(str = [_ | _]) do
    {a, str} = str |> skip_whitespace() |> number()
    {op, str} = str |> skip_whitespace() |> operator()
    {b, str} = str |> skip_whitespace() |> number()
    ~c"" = skip_whitespace(str)
    op.(a, b)
  end
end
