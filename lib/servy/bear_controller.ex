defmodule Servy.BearController do
  def index(conv) do
    %{ conv | resp_body: "Teddy, Smokey, Paddington", status: 200}
  end

  def show(conv, id) do
    %{ conv | resp_body: "Bear #{id}", status: 200}
  end
end
