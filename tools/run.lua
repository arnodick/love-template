local run = function(libraryname, functionname,...)
	--runs a function in a library, after checking to make sure it exists
	local libraryfunction=_G[libraryname][functionname]
	if libraryfunction then
		libraryfunction(...)
		-- return libraryfunction(...)--is there any point in doing this?
	end
end

return run