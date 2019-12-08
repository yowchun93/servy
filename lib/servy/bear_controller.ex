defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear
  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(fn(b) -> Bear.is_grizzly?(b) end)
      |> Enum.sort(fn(b1, b2) -> Bear.order_asc_by_name(b1, b2) end)
      |> Enum.map(fn(b) -> "#{bear_item(b)}" end)
      |> Enum.join

    %{ conv | resp_body: items, status: 200}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{ conv | resp_body: "<h1>Bear #{bear_item(bear)}", status: 200}
  end

  def create(conv, %{"name" => name, "type" => type }) do
    %{ conv | status: 201,
      resp_body: "Create a #{type} bear named #{name}"}
  end

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end
end
