defmodule Bakery do
	def start(num_pid) when num_pid > 0 do
              newpid = spawn(__MODULE__, :wake_up, [])
	      send(newpid, {:ok, self()})
	      IO.puts " Customer PID formed #{inspect newpid}"
	      start(num_pid-1)
	  end

	
	def wake_up do
		IO.puts "#{inspect self} is listening"
	        receive do
			{:ok, sender} ->
			IO.puts "[#{inspect sender}] A new customer has just arrived #{inspect self()}"
		end
	end
end
			
