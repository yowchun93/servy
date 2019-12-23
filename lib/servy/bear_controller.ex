defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.View

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(fn(b1, b2) -> Bear.order_asc_by_name(b1, b2) end)

    View.render(conv, "index.eex", [bears: bears])
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    View.render(conv, "show.eex", [bear: bear])
  end

  def create(conv, %{"name" => name, "type" => type }) do
    %{ conv | status: 201,
      resp_body: "Create a #{type} bear named #{name}"}
  end

  def delete(conv) do
    %{ conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end

  # defp bear_item(bear) do
  #   "<li>#{bear.name} - #{bear.type}</li>"
  # end
end
