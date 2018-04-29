defmodule Manager do
	def manage(serverlist) do
		receive do
		{:addserver, serverpid} ->
				 #IO.puts"Server process #{inspect self()} is adding #{inspect serverpid} to list"
				 serverlist = serverlist ++ [serverpid] 
		{:pairwithserver, customerpid, randvalue} ->
				freeserver = Enum.at(serverlist,0)
				if freeserver != nil do
				send(freeserver, {:compute, customerpid, randvalue})
				serverlist = List.delete_at(serverlist,0)
				else
				send(:manager, {:hold, customerpid, randvalue})
				end
		{:hold, customerpid, randvalue} ->
				send(:manager, {:pairwithserver, customerpid, randvalue})
		end		
		#IO.puts"#{inspect serverlist} here it is"
		manage(serverlist)
	end
	
end
