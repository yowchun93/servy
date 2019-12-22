defmodule Servy.Plugins do
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

  # "/bears?id=1"
  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(conv) do
    conv
  end

  def rewrite_path_captures(conv, %{id: id, thing: thing}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(conv, _) do
    conv
  end

  def log(conv) do
    IO.inspect conv
  end

  def emojify(%{status: 200} = conv) do
    # new_resp_body = "😄" <>  "\n" <> conv.resp_body <> "\n" <> "😄"
    %{ conv | resp_body: conv.resp_body}
  end

  def emojify(%{status: 404} = conv) do
    conv
  end

  def emojify(conv) do
    conv
  end
end
