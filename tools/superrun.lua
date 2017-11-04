--[[
local superrun = function(t,args)
	if #args>0 then
		if t[args[1] ] then
			local t2=table.remove()
			superrun()
		end
	end
	--runs a function in a library, after checking to make sure it exists
	if _G[libraryname] [functionname] then
		_G[libraryname] [functionname](...)
	end
end

return superrun
--]]