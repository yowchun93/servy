defmodule ClosureExample do
  def create_some_function(number) do
    fn -> IO.puts(number) end
  end
end

# some_function = Example.create_some_function(5)
# some_function.()
