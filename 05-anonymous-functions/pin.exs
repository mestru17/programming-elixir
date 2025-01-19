defmodule Greeter do
  def for(name, greeting) do
    fn
      ^name -> "#{greeting} #{name}"
      _ -> "I don't know you"
    end
  end
end

mr_valim = Greeter.for("José", "Oi!")

# => Oi! José
IO.puts(mr_valim.("José"))

# => I don't know you
IO.puts(mr_valim.("Dave"))
