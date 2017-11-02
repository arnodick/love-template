local flags={}

flags.get = function(bytes,flag,shift)
	--takes a hex flag variable and an integer flag position
	--returns true if that flag position is set
	flag = flags.tohex(flag)
	if shift then
		bytes=bit.rshift(bytes,shift)
	end
	if bit.band(bytes,flag) == flag then --checks if flag f is set in flags. ignores other flags.
		return true
	else
		return false
	end
end

flags.set = function (bytes,...)
	--takes a hex flag variable and a table of flag positions
	--SETS the bit pointed to by each flag position
	--only turns ON bits pointed to by the flag positions input
	local f={...}
	for a=1,#f do
		--local flag = 2^(flags[a]-1) 
		local flag = flags.tohex(f[a])
		bytes=bit.bor(bytes,flag)
	end

	--TODO maybe here do flag-specific function?
	--ie run(flagname,make(a,...))
	return bytes
end

--TODO make the ... into a f var that tests whether it's a table or not
flags.switch = function (bytes,...)
	--takes a hex flag variable and a table of flag positions
	--SWITCHES the bit pointed to by each flag position
	--doesn't just turn ON bits, can turn OFF a bit by using a flag position that has already been set in the byte
	local f={...}
	for a=1,#f do
		local flag = flags.tohex(f[a])
		bytes=bit.bxor(bytes,flag)
	end
	return bytes
end

flags.strip = function(bytes)
	--takes only a hex value
	--set all the flag bits (high 16 bits) in the hex value and makes them 0
	bytes=bit.band(bytes,65535)
	return bytes
end

flags.tohex = function(position)
	--converts flag position to its actual hex number value (ie: f 1 = 1, f 2 = 2, f 3 = 4, f 4 = 8 etc.)
	return 2^(position-1)
end

return flags