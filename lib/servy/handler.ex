defmodule Servy.Handler do

  # request = """
  # GET /wildthings HTTP/1.1
  # Host: example.com
  # User-Agent: ExampleBrowser/1.0
  # Accept: */*
  # """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    |> track
    |> format_response
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv) do
    conv
  end

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings"}
  end

  def rewrite_path(conv) do
    conv
  end

  def log(conv) do
    IO.inspect conv
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    %{ method: method, path: path, resp_body: "", status: nil}
  end

  # can be refactored to match against the Conv map
  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{ conv | resp_body: "Teddy, Smokey, Paddington", status: 200}
  end

  # /bears/1
  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{ conv | resp_body: "Bear #{id}", status: 200}
  end

  # /bears?id=1
  def route(%{method: "GET", path: "/bears?id=" <> id} = conv) do
    %{ conv | resp_body: "Bear #{id}", status: 200}
  end

  def route(%{method: "GET", path: path} = conv) do
    %{ conv | resp_body: "No #{path} here!", status: 404}
  end

  def route(%{method: "DELETE", path: "/bears" <> _} = conv) do
    %{ conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end


  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

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


# response = Servy.Handler.handle(request)
