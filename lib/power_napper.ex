defmodule PowerNapper do

  def simulate_napping do
    power_nap = fn ->
      time = :rand.uniform(10_000)
      :timer.sleep(time)
      time
    end

    parent = self()
    IO.inspect(parent) # PID

    spawn(fn -> send(parent, {:slept, power_nap.()}) end)

    # Receive is a blocking process, which means it will not terminate, unless a receive is given?
    receive do
      {:slept, time} -> IO.puts "Slept #{time} ms"
    end
  end

end
