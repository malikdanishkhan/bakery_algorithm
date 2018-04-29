defmodule Bakery do
	def start(num_c, num_s) do
	serverlist = []
	manager = spawn(Manager, :manage, [serverlist])
	Process.register(manager, :manager)
	Server.create_servers(num_s)
	Customer.create_customers(num_c)
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
	#IO.puts"Adding server #{inspect firstserver} to Server List"
	send(:manager, {:addserver, firstserver})
	add_servers(servers,num_s-1, index+1)
  	 
        end
	def add_servers(servers, 0, index) do
	IO.puts"Done creating servers"
	end
	
	def something do
	end
	 
end

defmodule Customer do
	def create_customers(num_c) do	
	#Creating customer PIDS
	customers = (1..num_c) |> Enum.map(fn (n) -> spawn(__MODULE__, :somethingelse, []) end)
	#IO.puts"New cust PID #{inspect customers}"	
	#Putting customers to sleep for random time (to simulate customers arriving at different times)
	good_night(customers, num_c, 0)
	end

	def good_night(customers, num_c, index) when num_c > 0 do
	currentcustomer = Enum.at(customers,index)
	IO.puts"#{inspect self()} PROCESS -- Customers are here to sleep #{inspect currentcustomer}"
	#time_sleep = :rand.uniform(4000)
	#:timer.sleep(time_sleep)
	#IO.puts"Just woke up"
	good_night(customers, num_c-1, index+1)
	send(currentcustomer, {:arrival, currentcustomer})
	end
	def good_night(customers, 0, index) do
	IO.puts("All customers are asleep")
	end	

	def somethingelse do
		receive do
		{:arrival, customerpid} ->
				IO.puts(" #{inspect self()} GOT CUSTOMER #{inspect customerpid}")
				
		end		
	end

end	

defmodule Manager do
	def manage(serverlist) do
		receive do
		{:addserver, serverpid} ->
				 #IO.puts"Server process #{inspect self()} is adding #{inspect serverpid} to list"
				 serverlist = serverlist ++ [serverpid] 
		end
		IO.puts"#{inspect serverlist} here it is"
		manage(serverlist)
	end
	
end		
