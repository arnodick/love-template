local module={}

module.make = function(a,t,...)
	local modulename=t--TODO can get rid of this, just input string
	if type(t)=="number" then--TODO this will go too
		modulename=EM[t]
	end
	if not a[modulename] then
		a[modulename]={}
	end
	
	local m=a[modulename]

	run(modulename,"make",a,m,...)
end

module.destroy = function(a,m)
end

return module