defmodule Bakery do
	def start(num_c, num_s) do
	serverlist = []
	manager = spawn(Manager, :manage, [serverlist])
	Process.register(manager, :manager)
	Server.create_servers(num_s)
	Customer.create_customers(num_c)
	end
end
