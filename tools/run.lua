local run = function(libraryname, functionname,...)
	--runs a function in a library, after checking to make sure it exists
	if _G[libraryname][functionname] then
		_G[libraryname][functionname](...)
	end
end

return run