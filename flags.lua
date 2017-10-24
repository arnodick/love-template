local flags={}

flags.get = function(bytes,f,shift)
	--takes a hex flag variable and an integer flag position
	--returns true if that flag position is set
	local flag = 2^(f-1) --converts flag position to its actual hex number value (ie: f 1 = 1, f 2 = 2, f 3 = 4, f 4 = 8 etc.)
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
	--returns updated flags
	local flags={...}
	for a=1,#flags do
		local flag = 2^(flags[a]-1) --converts flag position to its actual hex number value (ie: f 1 = 1, f 2 = 2, f 3 = 4, f 4 = 8 etc.)
		bytes=bit.bor(bytes,flag)
	end
	return bytes
end

flags.switch = function (bytes,...)
	--takes a hex flag variable and a table of flag positions
	--SWITCHES the bit pointed to by each flag position
	--doesn't just turn ON bits, can turn OFF a bit by using a flag position that has already been set in the byte
	--returns updated flags
	local flags={...}
	for a=1,#flags do
		local flag = 2^(flags[a]-1) --converts flag position to its actual hex number value (ie: f 1 = 1, f 2 = 2, f 3 = 4, f 4 = 8 etc.)
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

return flags