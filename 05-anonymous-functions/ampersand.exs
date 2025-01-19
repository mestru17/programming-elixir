# Exercise: Functions-5

# => [3, 4, 5, 6]
IO.inspect(Enum.map([1, 2, 3, 4], &(&1 + 2)))

# => 1
#    2
#    3
#    4
Enum.map([1, 2, 3, 4], &IO.inspect/1)
