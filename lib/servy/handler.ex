defmodule Servy.Handler do

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1, emojify: 1]
  import Servy.Parser, only: [parse: 1]
  # request = """
  # GET /wildthings HTTP/1.1
  # Host: example.com
  # User-Agent: ExampleBrowser/1.0
  # Accept: */*
  # """
  def handle(request) do
    request
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> emojify
    |> track
    |> format_response
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{ conv | resp_body: "Teddy, Smokey, Paddington", status: 200}
  end

  def route(%{method: "GET", path: "/bears/new"} = conv) do
    file =
      @pages_path
      |> Path.join("form.html")
    case File.read(file) do
      {:ok, content} ->
        %{ conv | status: 200, resp_body: content }
      {:error, :enoent} ->
        %{ conv | status: 404, resp_body: "File not found"}
      {:error, reason} ->
        %{ conv | status: 500, resp_body: "File error: #{reason}"}
    end
  end

  # /bears/1
  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{ conv | resp_body: "Bear #{id}", status: 200}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    file =
      @pages_path
      |> Path.join("about.html")

    case File.read(file) do
      {:ok, content} ->
        %{ conv | status: 200, resp_body: content }
      {:error, :enoent} ->
        %{ conv | status: 404, resp_body: "File not found"}
      {:error, reason} ->
        %{ conv | status: 500, resp_body: "File error: #{reason}"}
    end
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
