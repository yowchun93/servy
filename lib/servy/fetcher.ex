defmodule Servy.Fetcher do
  # def async(camera_name) do
  #   parent = self()

  #   spawn(fn -> send(parent, {:result, Servy.VideoCam.get_snapshot(camera_name)}) end)
  # end

  ## allow async to be passed in function instead of camera_name
  def async(fun) do
    parent = self()

    spawn(fn -> send(parent, {:result, fun.()}) end)
  end

  def get_result do
    receive do
      {:result, value} -> value
    end
  end
end
