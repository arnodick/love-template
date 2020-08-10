--TODO maybe put this in love.filesystem?
local textfile={}

local byteamount=4--4 bytes (8 hex digits) per cell
local hexamount=byteamount*2--8 hex digits per cell

--converts a line of hex text into values and inserts them into a 1D array
--data is the table we will load hex data into as a 1D array, l is a line of hex data as a string
textfile.loadbytes = function(data,l)
	local w=0
	for a=1,#l,hexamount do
		w=w+1
		local val=tonumber(string.sub(l,a,a+hexamount-1),16)
		table.insert(data,val)
	end
	return w
end

--loads hex values from a textfile row by row into an array
--returns a 1D array of datums, the width of the textfile's data (how many values are in each row) and the height in rows of the textfile's data
--f is the file name of the textfile we are loading from
textfile.load = function(f)
	local data={}
	local w=nil
	local h=0

	for row in love.filesystem.lines(f) do
		h=h+1
		local cellwidth=textfile.loadbytes(data,row)
		if w==nil then
			w=cellwidth
		end
	end

	return data,w,h
end

--TODO move map stuff out of here. maybe map just does all this stuff, and has function for the str=str stuff below?
textfile.save = function(m,name)
	--takes an array of hex data and a filename string
	--converts hex data into text and saves it in a file

	local str=""
	for y=1,m.h do
		for x=1,m.w do
			str=str..string.format("%0"..tostring(hexamount).."x",m[map.getindex(m,x,y)])
		end
		str=str.."\n"
	end
	love.filesystem.write(name,str)
end

return textfile