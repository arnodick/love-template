---[[
local supperrun = function(t,args,...)
	if #args>0 then
		local f=t[args[1]]
		if f then
			print("doin "..args[1])
			table.remove(args,1)
			supperrun(f,args,...)
		end
	elseif type(t)=="function" then
		t(...)
	else
		print("nun funcy")
	end
end

return supperrun
--]]