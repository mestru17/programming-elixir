# Exercise: Functions-4
prefix =
  fn prefix ->
    fn suffix -> "#{prefix} #{suffix}" end
  end

mrs = prefix.("Mrs")
# => Mrs Smith
IO.puts(mrs.("Smith"))

# => Elixir Rocks
IO.puts(prefix.("Elixir").("Rocks"))
