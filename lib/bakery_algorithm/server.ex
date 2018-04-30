defmodule Server do
	def create_servers(num_s) do
	servers = (1..num_s) |> Enum.map(fn (n) -> spawn(__MODULE__, :server_process, []) end)
	IO.puts("List of new servers #{inspect servers}")
	
	#Add servers to server list
	add_servers(servers, num_s, 0)
	end
	
	#Manager adds each server to a list of servers
	def add_servers(servers, num_s, index) when num_s > 0 do 
	firstserver = Enum.at(servers, index)

	#Manager adds servers to free server list
	send(:manager, {:addserver, firstserver})
	add_servers(servers,num_s-1, index+1)
        end
	def add_servers(servers, 0, index) do
	IO.puts"Done creating and adding servers to list"
	end
	
	def server_process do
		receive do
		{:compute, customerpid, randvalue} ->
					fibresult = fib(randvalue)
					
					#Server sends the customer the result
					send(customerpid, {:served, fibresult})
					
					#Manager adds server back to free server list
					send(:manager, {:addserver, self()})
		end
		server_process
	end
	
	defp fib(0) do 0 end
	defp fib(1) do 1 end
	defp fib(n) do fib(n-1) + fib(n-2) end
end

