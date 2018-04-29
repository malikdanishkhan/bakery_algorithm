defmodule Customer do
	def create_customers(num_c) do	
	#Creating customer PIDS
	customers = (1..num_c) |> Enum.map(fn (n) -> spawn(__MODULE__, :somethingelse, []) end)
	IO.puts"New customers created #{inspect customers}"	
	#Putting customers to sleep for random time (to simulate customers arriving at different times)
	good_night(customers, num_c, 0)
	end
	#Puts customers to sleep
	def good_night(customers, num_c, index) when num_c > 0 do
	currentcustomer = Enum.at(customers,index)
	#IO.puts"#{inspect self()} PROCESS -- Customers are here to sleep #{inspect currentcustomer}"
	good_night(customers, num_c-1, index+1)
	send(currentcustomer, {:arrival, currentcustomer})
	end
	def good_night(customers, 0, index) do
	IO.puts("Store is ready for customers!")
	end	

	def somethingelse do
		receive do
		{:arrival, customerpid} ->
			       #IO.puts(" #{inspect self()} GOT CUSTOMER #{inspect customerpid}")
				time_sleep = :rand.uniform(2000)
				:timer.sleep(time_sleep)
				IO.puts("CUSTOMER #{inspect customerpid} just arrived!")
				randvalue = :rand.uniform(20)
				send(:manager, {:pairwithserver, customerpid, randvalue})
		{:served, fibresult} ->
				IO.puts"Customer #{inspect self()}  was served with #{fibresult}"
		end
		somethingelse	
	end

end	
