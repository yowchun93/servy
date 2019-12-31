defmodule Servy.PledgeController do
  def create(conv, %{"name" => name, "amount" => amount}) do
    Servy.PledgeServer.create_pledge(name, amount)

    %{ conv | status: 201, resp_body: "#{name} pledged #{amount}!" }
  end

  def index(conv) do
    # Gets the recent pledges from the cache
    pledges = Servy.PledgeServer.recent_pledges()

    %{ conv | status: 200, resp_body: (inspect pledges) }
  end
end
