defmodule Servy.Api.BearController do
  def index(conv) do
    {:ok, bears } = Servy.Wildthings.list_bears
    |> Poison.encode
    %{ conv | resp_body: bears, resp_content_type: "application/json", status: 200}
  end
end
