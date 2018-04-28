defmodule Bakery do
	def start(num_s) do
	serverlist = []
	manager = spawn(Manager, :manage, [serverlist])
	Process.register(manager, :manager)
	Server.create_servers(num_s)
	end
end

defmodule Server do
	def create_servers(num_s) do
	servers = (1..num_s) |> Enum.map(fn (n) -> spawn(__MODULE__, :something, []) end)
	IO.puts("List of server PIDS created #{inspect servers}")
	add_servers(servers, num_s, 0)
	end
	
	def add_servers(servers, num_s, index) when num_s > 0 do 
	firstserver = Enum.at(servers, index)
	IO.puts"Adding server #{inspect firstserver} to Server List"
	send(:manager, {:addserver, firstserver})
	add_servers(servers,num_s-1, index+1)
  	 
        end
	def add_servers(servers, 0, index) do
	IO.puts"Done creating servers"
	end
	
	def something do
	end
	 
end
		

defmodule Manager do
	def manage(serverlist) do
		receive do
		{:addserver, serverpid} ->
				 IO.puts"Server process #{inspect self()} is adding #{inspect serverpid} to list"
				 serverlist = serverlist ++ [serverpid] 
		end
		IO.puts"#{inspect serverlist} here it is"
		manage(serverlist)
	end
	
end		
