defmodule Servy.Handler do

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Plugins, only: [ log: 1, track: 1, emojify: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  alias Servy.Conv, as: Conv
  alias Servy.BearController

  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> emojify
    |> track
    |> put_content_length
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/"} = conv) do
    %{conv | resp_body: "Hello welcome"}
  end

  def route(%Conv{method: "GET", path: "/pledges/new"} = conv) do
    Servy.PledgeController.new(conv)
  end

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    sensor_data = Servy.SensorServer.get_sensor_data()

    %{ conv | status: 200, resp_body: inspect sensor_data}
  end

  def route(%Conv{method: "GET", path: "/kaboom"} = _conv) do
    raise "Kaboom"
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer |> :timer.sleep

    %{ conv | status: 200, resp_body: "Awake!"}
  end

  @spec route(Servy.Conv.t()) :: %{resp_body: any, status: 200 | 201 | 403 | 404 | 500}
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.Api.BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  # /bears/1
  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  # name=Baloo&type=Brown
  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/faq"} = conv) do
    @pages_path
    |> Path.join("faq.md")
    |> File.read!
    |> Earmark.as_html!
    %{ conv | resp_body: Earmark.as_html!(conv.resp_body) }
  end

  def route(%Conv{method: "GET", path: path} = conv) do
    %{ conv | resp_body: "No #{path} here!", status: 404}
  end

  def route(%Conv{method: "DELETE", path: "/bears" <> _} = conv) do
    BearController.delete(conv)
  end

  def put_content_length(conv) do
    %{ conv | resp_headers: Map.put(conv.resp_headers, "Content-Length", String.length(conv.resp_body))}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}\r
    Content-Type: #{conv.resp_headers["Content-Type"]}\r
    Content-Length: #{conv.resp_headers["Content-Length"]}\r
    \r
    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end
