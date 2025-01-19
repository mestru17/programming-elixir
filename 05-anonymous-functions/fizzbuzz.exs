# Exercise: Functions-2
fb = fn
  0, 0, _ -> "FizzBuzz"
  0, _, _ -> "Fizz"
  _, 0, _ -> "Buzz"
  _, _, n -> n
end

# => FizzBuzz
IO.puts(fb.(0, 0, 42))
# => Fizz
IO.puts(fb.(0, 42, 42))
# => Buzz
IO.puts(fb.(42, 0, 42))
# => 42
IO.puts(fb.(42, 42, 42))

# Exercise: Functions-3
fbn = fn n -> fb.(rem(n, 3), rem(n, 5), n) end

IO.puts("")
# => Buzz
IO.puts(fbn.(10))
# => 11
IO.puts(fbn.(11))
# => Fizz
IO.puts(fbn.(12))
# => 13
IO.puts(fbn.(13))
# => 14
IO.puts(fbn.(14))
# => FizzBuzz
IO.puts(fbn.(15))
# => 16
IO.puts(fbn.(16))
