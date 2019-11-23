defmodule ServyTest do
  use ExUnit.Case
  doctest Servy

  test "/wildthings" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    """
    IO.puts Servy.Handler.handle(request)
  end

  test "bear url with Id" do
    request = """
    GET /bears/1 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    """
    IO.puts Servy.Handler.handle(request)
  end

  test "bear different url with Id" do
    request = """
    GET /bears?id=1 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    """
    IO.puts Servy.Handler.handle(request)
  end

  test "unknown url" do
    request = """
    GET /bigfoot HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    """
    IO.puts Servy.Handler.handle(request)
  end

  test "/wildlife url, parsed to /wildthings" do
    request = """
    GET /wildlife HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    """
    IO.puts Servy.Handler.handle(request)
  end

end
