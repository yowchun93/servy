defmodule ImageApi do
  # def query(request) do
  #   {code, http_response} = HTTPoison.get("https://api.myjson.com/bins/#{request}")

  #   if code == :ok do
  #     image_url = Poison.Parser.parse!(http_response.body, %{}) |> get_in(["image", "image_url"])
  #     {code, image_url}
  #   else
  #     {code, http_response.reason}
  #   end
  # end

  @doc """
    ImageApi.query("16x3i5")
  """
  def query(id) do
    api_url(id)
    |> HTTPoison.get
    |> handle_response
  end

  defp api_url(id) do
    "https://api.myjson.com/bins/#{URI.encode(id)}"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    image_url = Poison.decode!(body, %{})
    |> get_in(["image", "image_url"])
    {:ok, image_url}
  end

  defp handle_response({:ok, %{status_code: _status, body: body}}) do
    message = Poison.decode!(body, %{})
    |> get_in(["message"])
    {:error, message}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
