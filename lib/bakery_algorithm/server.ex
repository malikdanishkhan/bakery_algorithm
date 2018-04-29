defmodule Server do
	def create_servers(num_s) do
	servers = (1..num_s) |> Enum.map(fn (n) -> spawn(__MODULE__, :something, []) end)
	IO.puts("List of server PIDS created #{inspect servers}")
	add_servers(servers, num_s, 0)
	end
	
	def add_servers(servers, num_s, index) when num_s > 0 do 
	firstserver = Enum.at(servers, index)
	#IO.puts"Adding server #{inspect firstserver} to Server List"
	send(:manager, {:addserver, firstserver})
	add_servers(servers,num_s-1, index+1)
        end
	def add_servers(servers, 0, index) do
	IO.puts"Done creating servers"
	end
	
	def something do
		receive do
		{:compute, customerpid, randvalue} ->
					fibresult = fib(randvalue)
					send(customerpid, {:served, fibresult})
					send(:manager, {:addserver, self()})
		end
		something
	end
	
	defp fib(0) do 0 end
	defp fib(1) do 1 end
	defp fib(n) do fib(n-1) + fib(n-2) end
end

