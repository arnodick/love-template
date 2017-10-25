local run = function(libraryname, functionname, ...)
	if _G[libraryname][functionname] then
		_G[libraryname][functionname](...)
	end
end

return run