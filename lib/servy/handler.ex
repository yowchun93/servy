defmodule Servy.Handler do

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1, emojify: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  alias Servy.Conv, as: Conv
  alias Servy.BearController
  alias Servy.VideoCam
  alias Servy.Fetcher

  def handle(request) do
    request
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> emojify
    |> track
    |> put_content_length
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/"} = conv) do
    %{conv | resp_body: "Hello welcome"}
  end

  def route(%Conv{method: "GET", path: "/snapshots"} = conv) do
    Fetcher.async(fn -> Servy.VideoCam.get_snapshot("cam-1") end)
    Fetcher.async(fn -> Servy.VideoCam.get_snapshot("cam-2") end)
    Fetcher.async(fn -> Servy.VideoCam.get_snapshot("cam-3") end)

    snapshot1 = Fetcher.get_result
    snapshot2 = Fetcher.get_result
    snapshot3 = Fetcher.get_result

    snapshots = [snapshot1, snapshot2, snapshot3]
    %{ conv | status: 200, resp_body: inspect(snapshots)}
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
