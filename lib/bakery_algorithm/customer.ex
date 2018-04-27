defmodule Main do
	def start(num_customers, num_servers) do

	Server.create_servers(num_servers)
	Customer.create_customers(num_customers)
	end
end

defmodule Customer do
	def create_customers(num_customers) when num_customers >= 0 do
              newcustpid = spawn(__MODULE__, :wake_up, [])
	      send(newcustpid, {:incoming, self()})
	      IO.puts " Customer PID formed #{inspect newcustpid}"
	      create_customers(num_customers-1)
        end
	def create_customers(num_customers) do
	end

             	
	def wake_up do
	     IO.puts "#{inspect self} is listening"
	        receive do
			{:incoming, sender} ->
			sleep = :rand.uniform(10000)
			:timer.sleep(sleep)
			IO.puts "[#{inspect sender}] A new customer has just arrived #{inspect self()}"
		end
	end
end

defmodule Server do
	def create_servers(num_servers) when num_servers >= 0 do
              newserverpid = spawn(__MODULE__, :something, [])
	      send(newserverpid, {:serverCreated, self()})
	      IO.puts " Server formed #{inspect newserverpid}"
	      create_servers(num_servers-1)
	end
	def create_servers(num_servers) do
	end

	def something do
               receive do
	       {:serverCreated, newserverpid} -> IO.puts"New server"
	       end
        end
end

defmodule Manager do
    def match(servers) do
	receive do
		{:addserver, newserverpid} -> servers = servers ++ [newserverpid]
        end
    end
end
			
