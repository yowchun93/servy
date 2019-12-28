defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  # test "accepts a request on a socket and sends back response" do
  #   spawn(HttpServer, :start, [4000])

  #   request = """
  #   GET /wildthings HTTP/1.1\r
  #   Host: example.com\r
  #   User-Agent: ExampleBrowser/1.0\r
  #   Accept: */*\r
  #   \r
  #   """

  #   response = HttpClient.send_request(request)

  #   assert response == """
  #   HTTP/1.1 200 OK\r
  #   Content-Type: text/html\r
  #   Content-Length: 20\r
  #   \r
  #   Bears, Lions, Tigers
  #   """
  # end

  # test "accepts a request and sends back a response" do
  #   spawn(HttpServer, :start, [4000])

  #   {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"

  #   assert response.status_code == 200
  #   assert response.body == "Bears, Lions, Tigers"
  # end

  test "accepting request concurrently" do
    spawn(HttpServer, :start, [4000])

    parent = self()

    max_concurrent_requests = 5

    for  _ <- 1..max_concurrent_requests do
      spawn(fn ->
        {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"
        send(parent, {:ok, response})
      end)
    end

    for  _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end

  end
end
