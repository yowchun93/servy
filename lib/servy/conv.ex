defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil, params: %{}, headers: %{}, resp_headers: %{"Content-Type" => "text/html"}

end
