# Exercise: StringsAndBinaries-7
defmodule Orders do
  def tax_rates do
    [NC: 0.075, TX: 0.08]
  end

  def orders do
    [
      [id: 123, ship_to: :NC, net_amount: 100.00],
      [id: 124, ship_to: :OK, net_amount: 35.50],
      [id: 125, ship_to: :TX, net_amount: 24.00],
      [id: 126, ship_to: :TX, net_amount: 44.80],
      [id: 127, ship_to: :NC, net_amount: 24.00],
      [id: 128, ship_to: :MA, net_amount: 10.00],
      [id: 129, ship_to: :CA, net_amount: 102.00],
      [id: 130, ship_to: :NC, net_amount: 50.00]
    ]
  end

  def apply_tax([NC: nc, TX: tx], orders) when is_list(orders) do
    for [id: id, ship_to: ship_to, net_amount: net_amount] <- orders do
      total_amount =
        case ship_to do
          :NC -> net_amount + nc * net_amount
          :TX -> net_amount + tx * net_amount
          _ -> net_amount
        end

      [id: id, ship_to: ship_to, net_amount: net_amount, total_amount: total_amount]
    end
  end

  def parse_field_name("id") do
    :id
  end

  def parse_field_name("ship_to") do
    :ship_to
  end

  def parse_field_name("net_amount") do
    :net_amount
  end

  def parse_field_name(name) when is_binary(name) do
    raise("Invalid column name '#{name}'")
  end

  def parse_field(:id, id) when is_binary(id) do
    String.to_integer(id)
  end

  def parse_field(:ship_to, <<":"::utf8, tail::binary>>) do
    String.to_existing_atom(tail)
  end

  def parse_field(:ship_to, ship_to) when is_binary(ship_to) do
    raise "Invalid ship_to value '#{ship_to}'"
  end

  def parse_field(:net_amount, net_amount) when is_binary(net_amount) do
    String.to_float(net_amount)
  end

  def parse_field(name, value) when is_atom(name) and is_binary(value) do
    raise "Invalid field name '#{name}'"
  end

  def parse_row(line) when is_binary(line) do
    line
    |> String.trim()
    |> String.split(",")
  end

  def parse_header_row(line) when is_binary(line) do
    {field_names, _} =
      line
      |> parse_row()
      |> Enum.map_reduce([], fn name, names ->
        if name in names do
          raise "Duplicate field name in row header '#{name}'"
        else
          {parse_field_name(name), [name | names]}
        end
      end)

    field_names
  end

  def parse_file(file) when is_binary(file) do
    {:ok, orders} =
      File.open(file, [:read, :utf8], fn file ->
        field_names =
          file
          |> IO.read(:line)
          |> parse_header_row()

        file
        |> IO.stream(:line)
        |> Enum.map(&parse_row/1)
        |> Enum.map(fn values ->
          field_names
          |> Enum.zip(values)
          |> Enum.map(fn {name, value} -> {name, parse_field(name, value)} end)
        end)
      end)

    orders
  end

  def apply_tax_to_file(file) when is_binary(file) do
    apply_tax(tax_rates(), parse_file(file))
  end
end
