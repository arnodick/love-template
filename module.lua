local module={}

module.make = function(a,t,...)
	--TODO realistically, could just do away with enums here and input string: modulename = t, a[modeulneame]={}
	--or could jsut do both: if t==string then a[modulename]={} else EM[t] stuff
	--if type(t)=="string" then
---[[
	local modulename=t
	if type(t)=="number" then
		modulename=EM[t]
	end
	if not a[modulename] then
		a[modulename]={}
	end
--]]
--[[
	local modulename=EM[t]
	if not a[modulename] then
		a[modulename]={}
	end
--]]
	
	local m=a[modulename]

	run(modulename,"make",a,m,...)
end

module.destroy = function(a,m)
end

return module