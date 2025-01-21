# Exercise: ControlFlow-3
defmodule Ok do
  def ok!({:ok, data}), do: data
  def ok!({:error, message}), do: raise "Error: #{message}"
  def ok!(not_ok), do: raise "Not ok: #{inspect(not_ok)}"
end
