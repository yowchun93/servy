defmodule Servy.Api.BearController do
  def index(conv) do
    {:ok, bears } = Servy.Wildthings.list_bears
    |> Poison.encode

    conv = put_resp_content_type(conv, "application/json")
    %{conv | resp_body: bears, status: 200}
  end

  def create(conv, %{"name" => _name, "type" => _type }) do
    IO.inspect conv
    %{conv | resp_body: "Created a Polar bear named Breezly!", status: 201}
  end

  defp put_resp_content_type(conv, content_type) do
    %{ conv | resp_headers: Map.put(conv.resp_headers, "Content-Type", content_type) }
  end
end
