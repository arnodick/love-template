local function make()
	local d={}
	d.debugging=false
	d.debuglist={}
	d.font = LG.newFont("fonts/lucon.ttf",20)
	d.canvas=LG.newCanvas(LG.getDimensions()) --sets width and height of debug overlay (size of window)
	return d
end

local function update(d)
	if d.debugging then
		local debuglist={}
		table.insert(debuglist,Game.timer)
		table.insert(debuglist,"Game speed: "..Game.speed)
		table.insert(debuglist,"Game state"..Game.state.st)
		table.insert(debuglist,"FPS:"..love.timer.getFPS())
		table.insert(debuglist,"Actors:"..#Game.actors)
		if Game.level then
			table.insert(debuglist,"Level:"..Game.level)
		end
		if Player then
			table.insert(debuglist,"player x:"..Player.x)
			table.insert(debuglist,"player y:"..Player.y)
			local xc,yc=map.getcell(Game.map,Player.x,Player.y)
			table.insert(debuglist,"player x cell:"..xc)
			table.insert(debuglist,"player y cell:"..yc)
			table.insert(debuglist,"player dir:"..Player.d)
			table.insert(debuglist,"player vx:"..Player.vec[1])
			table.insert(debuglist,"player vy:"..Player.vec[2])
			table.insert(debuglist,"player vel:"..Player.vel)
			table.insert(debuglist,"player input: "..tostring(Player.input))
			if Player.inventory then
				if Player.inventory[1] then
					table.insert(debuglist,"player item angle:"..Player.inventory[1].angle)
				end
			end
		end
--[[
		if Game.levels then
			if Game.levels.current then
				table.insert(debuglist,"spawn i: "..Game.levels.current.spawnindex)
			end
		end
--]]
		--table.insert(debuglist,"camx:"..Game.camera.x)
		--table.insert(debuglist,"camy:"..Game.camera.y)
		table.insert(debuglist,"pause: "..tostring(Game.pause))

		local levelpathstring=""
		if Game.levelpath then
			for i=1,#Game.levelpath do
				levelpathstring=levelpathstring..Game.levelpath[i]
				if i~=#Game.levelpath then
					levelpathstring=levelpathstring.."_"
				end
			end
		end
		table.insert(debuglist,"level path: "..levelpathstring)
--[[
		for i,v in pairs(Game.counters) do
			--table.insert(debuglist,i.." count: "..#Game.counters[i])
			table.insert(debuglist,i.." count: "..Game.counters[i])
		end
--]]
---[[
		if #Joysticks>0 then
			for i,v in ipairs(Joysticks) do
				table.insert(debuglist,"joy id: "..v:getID())
			end
		end

		if #Joysticks>0 then
			local axes={Joysticks[1]:getAxes()}
			table.insert(debuglist,"joy axes:"..#axes)
			for i=1,#axes do
				table.insert(debuglist,"axis"..i..":"..axes[i])
			end
		end
--]]
		d.debuglist=debuglist
	end
end

local function draw(d)
	if d.debugging then
		LG.setCanvas(d.canvas) --sets drawing to the 1280 x 960 debug canvas
		LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know

		LG.setFont(d.font)
		LG.setColor(Game.palette[11])
		LG.print("DEBUG",130,0)
		for i,v in ipairs(d.debuglist) do
			LG.print(v,10,10+d.font:getHeight()*i)
		end
		LG.setColor(Game.palette[16]) --sets draw colour back to normal
		LG.setFont(Game.font)

		LG.setCanvas() --sets drawing back to screen
		LG.origin()
		LG.draw(d.canvas,0,0,0,1,1) --just like draws everything to the screen or whatever
	end
end

local function printtable(table,space)
	space=space or ""
	for i,v in pairs(table) do
		print(space..i.." = "..tostring(v))
		if type(v)=="table" then
			printtable(v,space.." ")
		end
	end
end

return
{
	make = make,
	update = update,
	draw = draw,
	printtable = printtable,
}