# Exercise: ListsAndRecursion-8
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
end
