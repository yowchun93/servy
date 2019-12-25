defmodule HandlerTest do
  use ExUnit.Case
  # doctest Servy

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """
  end

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)
    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 605\r
    \r
    [{"type":"Brown","name":"Teddy","id":1,"hibernating":true},
     {"type":"Black","name":"Smokey","id":2,"hibernating":false},
     {"type":"Brown","name":"Paddington","id":3,"hibernating":false},
     {"type":"Grizzly","name":"Scarface","id":4,"hibernating":true},
     {"type":"Polar","name":"Snow","id":5,"hibernating":false},
     {"type":"Grizzly","name":"Brutus","id":6,"hibernating":false},
     {"type":"Black","name":"Rosie","id":7,"hibernating":true},
     {"type":"Panda","name":"Roscoe","id":8,"hibernating":false},
     {"type":"Polar","name":"Iceman","id":9,"hibernating":true},
     {"type":"Grizzly","name":"Kenai","id":10,"hibernating":false}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /api/bears" do
    request = """
    POST /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Breezly", "type": "Polar"}
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 35\r
    \r
    Created a Polar bear named Breezly!
    """
  end

  ## The extra Cookie line is fking up my API LOL
  test "GET real request from browser" do
    request = """
    "GET / HTTP/1.1\r\n
    Host: localhost:4000\r\n
    Connection: keep-alive\r\n
    Upgrade-Insecure-Requests: 1\r\n
    User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36\r\n
    Sec-Fetch-User: ?1\r\n
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9\r\n
    Sec-Fetch-Site: none\r\n
    Sec-Fetch-Mode: navigate\r\n
    Accept-Encoding: gzip, deflate, br\r\n
    Accept-Language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7,vi;q=0.6,zh-TW;q=0.5,ms;q=0.4\r\n
    Cookie: __smVID=59687cbc7fc87b5ad27299e95f133b145d7851d75467d2acd29057b7d203f0a9; locale=en-MY; rack.session=BAh7CkkiD3Nlc3Npb25faWQGOgZFVEkiRTc5YTEwNmVlZDc2ZmVhNTFkY2Yx%0AODM4ZDJhNzVmY2M0ZGVjMTA4NDE1N2ExMDgwMTg1YWYzN2Y5YzJlYTZlNTgG%0AOwBGSSIZd2FyZGVuLnVzZXIudXNlci5rZXkGOwBUWwdbBmkDmQ4BSSIiJDJh%0AJDEwJDAxam14cDJvaWJrWENPYUVuTmZJd2UGOwBUSSIQX2NzcmZfdG9rZW4G%0AOwBUSSIxWjltWkVheGFmN3hGck1PUSs3SzlwRVVETlNVdzNpK1VCSW9YRE90%0AK2VCND0GOwBUSSIJY3NyZgY7AFRJIjE5U1FHUXFOYXNUMURUZ3ZJczd0TmZp%0ATEhzanpLR2lmNXBKUUxFclNZZ2djPQY7AFRJIg10cmFja2luZwY7AFR7Bkki%0AFEhUVFBfVVNFUl9BR0VOVAY7AFRJIi01ZDRkY2QyOGRkYjk5MGNiNTE3Mzgx%0AM2IzNmNhMGZhZDkwOWRlODRkBjsAVA%3D%3D%0A--03dbf548b8241e8db2c796708389731bee8d4fe7; __smToken=83AKsQ6OYAguS9YR1FOQDwCX; _postco_session=bHQxTjJzVWFSRGlKNk8rUk15b2p5Ny9kNm1MbnB4cVBqMW93bitoYTlERTVKT21tV0loVW1jdS94NFFrdkFRLzc0R25iS1NVWW9qZWpNSVZ4M29zOXkyY29sejNvanVuVHZ2ckRCazRPT1haajJWaEREaHptNG5jcHZ6"
    """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end

end
