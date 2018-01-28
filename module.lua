local module={}

module.make = function(a,t,...)
	local modulename=t
	if type(t)=="number" then
		modulename=EM[t]
	end
--[[
	--old enum code
	local modulename=EM[t]
--]]
	if not a[modulename] then
		a[modulename]={}
	end
	
	local m=a[modulename]

	run(modulename,"make",a,m,...)
end

module.destroy = function(a,m)
end

return module