local function make()
	local d={}
	d.debugging=false
	d.debuglist={}
	d.font=LG.newFont("fonts/lucon.ttf",20)
	d.canvas=LG.newCanvas(LG.getDimensions()) --sets width and height of debug overlay (size of window)
	return d
end

local function update(g,d)
	if d.debugging then
		local debuglist={}
		table.insert(debuglist,g.timer)
		local trans=false
		if g.transition then
			trans=true
		end
		table.insert(debuglist,"Trans: "..tostring(trans))
		table.insert(debuglist,"Game speed: "..g.speed)
		table.insert(debuglist,"Game state"..g.state.st)
		table.insert(debuglist,"FPS:"..love.timer.getFPS())
		table.insert(debuglist,"Actors:"..#g.actors)
		if g.level then
			table.insert(debuglist,"Level:"..g.level)
		end
		if g.cursor then
			table.insert(debuglist,"cur x:"..g.cursor.x)
			table.insert(debuglist,"cur y:"..g.cursor.y)
		end
		if g.player then
			table.insert(debuglist,"player x:"..g.player.x)
			table.insert(debuglist,"player y:"..g.player.y)
			local xc,yc=map.getcell(g.map,g.player.x,g.player.y)
			table.insert(debuglist,"player x cell:"..xc)
			table.insert(debuglist,"player y cell:"..yc)
			if g.player.d then
			table.insert(debuglist,"player dir:"..g.player.d)
			end
			if g.player.vec then
			table.insert(debuglist,"player vec x:"..g.player.vec[1])
			table.insert(debuglist,"player vec y:"..g.player.vec[2])
			end
			if g.player.vel then
			table.insert(debuglist,"player vel:"..g.player.vel)
			end
			if g.player.input then
			table.insert(debuglist,"player input: "..tostring(g.player.input))
			end
			if g.player.controller then
			table.insert(debuglist,"player use dur: "..tostring(g.player.controller.action.useduration))
			end
			if g.player.inventory then
				if g.player.inventory[1] then
					table.insert(debuglist,"player item angle:"..g.player.inventory[1].angle)
				end
			end
		end
--[[
		if g.levels then
			if g.levels.current then
				table.insert(debuglist,"spawn i: "..g.levels.current.spawnindex)
			end
		end
--]]
		table.insert(debuglist,"camx:"..g.camera.x)
		table.insert(debuglist,"camy:"..g.camera.y)
		table.insert(debuglist,"cam zoom:"..g.camera.zoom)
		table.insert(debuglist,"pause: "..tostring(g.pause))

		local levelpathstring=""
		if g.levelpath then
			for i=1,#g.levelpath do
				levelpathstring=levelpathstring..g.levelpath[i]
				if i~=#g.levelpath then
					levelpathstring=levelpathstring.."_"
				end
			end
		end
		table.insert(debuglist,"level path: "..levelpathstring)
---[[
		for i,v in pairs(g.counters) do
			--table.insert(debuglist,i.." count: "..#g.counters[i])
			table.insert(debuglist,i.." count: "..g.counters[i])
		end
		if g.levels.current.transition then
			table.insert(debuglist,"trans timer "..g.levels.current.transition_timer)
		end
		if g.menu then
			if g.menu.transition then
				table.insert(debuglist,"text trans "..g.menu.text_trans)
			end
		end
--]]
--[[
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
		local g=Game
		LG.setCanvas(d.canvas) --sets drawing to the 1280 x 960 debug canvas
		LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know

		LG.setFont(d.font)
		LG.setColor(g.palette[11])
		LG.print("DEBUG",130,0)
		for i,v in ipairs(d.debuglist) do
			LG.print(v,10,10+d.font:getHeight()*i)
		end
		LG.setColor(g.palette[16]) --sets draw colour back to normal
		LG.setFont(g.font)

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