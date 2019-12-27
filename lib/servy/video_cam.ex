defmodule Servy.VideoCam do
  @doc """
    Simulate sending request to external API
  """
  def get_snapshot(camera) do
    :timer.sleep(2000)

    "#{camera}-snapshot.jpg"
  end
end
