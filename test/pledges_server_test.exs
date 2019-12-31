defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "creating 3 pledges" do
    PledgeServer.start()

    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)

    most_recent_pledges = [{"moe", 20}, {"larry", 10}]

    assert PledgeServer.recent_pledges == most_recent_pledges
  end
end
