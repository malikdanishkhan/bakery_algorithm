defmodule Manager do
	def start(num_customers) do
	Customer.create_customers(num_customers)
	end
end

defmodule Customer do
	def create_customers(num_customers) when num_customers > 0 do
              newcustpid = spawn(__MODULE__, :wake_up, [])
	      send(newcustpid, {:incoming, self()})
	      IO.puts " Customer PID formed #{inspect newcustpid}"
	      create_customers(num_customers-1)
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

		
