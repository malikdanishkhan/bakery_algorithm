defmodule Manager do
	def manage(serverlist) do
		receive do
		{:addserver, serverpid} ->
				 #Manager adds new server to free server list
				 serverlist = serverlist ++ [serverpid] 
		{:pairwithserver, customerpid, randvalue} ->
				freeserver = Enum.at(serverlist,0)

				#Finds a free server and pairs it up with a customer
				#if free server is not available, puts customer on hold
				if freeserver != nil do
				send(freeserver, {:compute, customerpid, randvalue})
				serverlist = List.delete_at(serverlist,0)
				else
				send(:manager, {:hold, customerpid, randvalue})
				end
		{:hold, customerpid, randvalue} ->
				send(:manager, {:pairwithserver, customerpid, randvalue})
		end		
		manage(serverlist)
	end
	
end
