defmodule Servy.PledgeController do
  import Servy.View

  def new(conv) do
    render(conv, "new_pledge.eex")
  end

  def create(conv, %{"name" => name, "amount" => amount}) do
    Servy.PledgeServer.create_pledge(name, amount)

    %{ conv | status: 201, resp_body: "#{name} pledged #{amount}!" }
  end

  def index(conv) do
    # Gets the recent pledges from the cache
    pledges = Servy.PledgeServer.recent_pledges()

    render(conv, "recent_pledges.eex", pledges: pledges)
  end
end
