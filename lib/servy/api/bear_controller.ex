defmodule Servy.Api.BearController do
  def index(conv) do
    {:ok, bears } = Servy.Wildthings.list_bears
    |> Poison.encode

    conv = put_resp_content_type(conv, "application/json")
    %{conv | resp_body: bears, status: 200}
  end

  defp put_resp_content_type(conv, content_type) do
    %{ conv | resp_headers: Map.put(conv.resp_headers, "Content-Type", content_type) }
  end
end
