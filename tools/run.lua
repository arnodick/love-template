local run = function(libraryname, functionname,...)
	--runs a function in a library, after checking to make sure it exists
	if _G[libraryname][functionname] then
		_G[libraryname][functionname](...)
		-- return _G[libraryname][functionname](...)--is there any point in doing this?
	end
end

return run