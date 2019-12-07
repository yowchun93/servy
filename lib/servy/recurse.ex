defmodule Servy.Recurse do
  # Exercise for recursion on Chapter 14
  def triple(list) do
    triple_recurse(list, [])
  end

  def triple_recurse([h | t], list) do
    new_list = [h * 3 | list ]
    triple_recurse(t, new_list)
  end

  def triple_recurse([], list) do
    list
    |> Enum.reverse
  end
end
