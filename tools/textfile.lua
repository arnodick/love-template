--TODO maybe put this in love.filesystem?
local textfile={}
textfile.flat={}

local byteamount=4--4 bytes (8 hex digits) per cell
local hexamount=byteamount*2--8 hex digits per cell

textfile.loadbytes = function(l,flatdata)
	--converts a line of hex text into values and inserts them into a 1D array
	--returns the 1D array
	if flatdata then
		local w=0
		for a=1,#l,hexamount do
			w=w+1
			local val=tonumber(string.sub(l,a,a+hexamount-1),16)
			table.insert(flatdata,val)
		end
		--TODO take this out of textfile, put in map
		if not flatdata.w then
			flatdata.w=w
			print("MAP WIDTH: "..flatdata.w)
		end
	else
		local ar={}
		for a=1,#l,hexamount do
			table.insert(ar,tonumber(string.sub(l,a,a+hexamount-1),16))
		end
		return ar
	end
end

textfile.flat.load = function(m)
	return love.filesystem.read(m)
	-- local data=love.filesystem.read(m)
	-- local ar={}
	-- for a=1,#data,hexamount do
	-- 	table.insert(ar,tonumber(string.sub(l,a,a+hexamount-1),16))
	-- end
	-- return ar
end

textfile.load = function(m,flat)
	--loads hex values from a textfile into an array row by row
	--returns a 2D array of datums
	local data={}
	if flat then
		-- table.insert(data,{})
		local h=0
		for row in love.filesystem.lines(m) do
			h=h+1
			textfile.loadbytes(row,data)
		end
		if not data.h then
			data.h=h
			print("MAP HEIGHT: "..data.h)
		end
		if not data.tile then
			data.tile={width=8,height=8}
		end
		data.width=data.w*data.tile.width
		data.height=data.h*data.tile.height
	else
		for row in love.filesystem.lines(m) do
			table.insert(data,textfile.loadbytes(row))
		end
	end
	return data
end

--TODO move map stuff out of here. maybe map just does all this stuff, and has function for the str=str stuff below?
textfile.save = function(m,name)
	--takes an array of hex data and a filename string
	--converts hex data into text and saves it in a file

	if not m.flat then
		local str=""
		for y=1,#m do
			for x=1,#m[y] do
				str=str..string.format("%0"..tostring(hexamount).."x",m[y][x])
			end
			str=str.."\n"
		end
		love.filesystem.write(name,str)
	else
		local str=""
		for y=1,m.h do
			for x=1,m.w do
				str=str..string.format("%0"..tostring(hexamount).."x",m[map.flat.getxy(m,x,y)])
			end
			str=str.."\n"
		end
		love.filesystem.write(name,str)
	end
end

return textfile