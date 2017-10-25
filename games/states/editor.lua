local function make(g)
	module.make(g.state,EM.cursor,EM.cursors.cursor_editor,true)
	module.make(g.camera,EM.target,g.state.cursor)

	if _G[Enums.games.states.editors[g.state.st]]["make"] then
		_G[Enums.games.states.editors[g.state.st]]["make"](g)
	end
end

local function control(g)
	cursor.update(g.state.cursor)
	if _G[Enums.games.states.editors[g.state.st]]["control"] then
		_G[Enums.games.states.editors[g.state.st]]["control"](g)
	end
	camera.control(g.camera,g.speed)
end

local function keypressed(g,key)
	if key=="escape" then
		game.state.make(g,Enums.games.states.gameplay)
	end
	if _G[Enums.games.states.editors[g.state.st]]["keypressed"] then
		_G[Enums.games.states.editors[g.state.st]]["keypressed"](g,key)
	end
end

local function mousepressed(g,x,y,button)
	if button==1 then
		cx,cy=map.getcell(g.map,g.state.cursor.x,g.state.cursor.y)
		g.map[cy][cx]=g.state.cursor.value
	end
	if _G[Enums.games.states.editors[g.state.st]]["mousepressed"] then
		_G[Enums.games.states.editors[g.state.st]]["mousepressed"](g,x,y,button)
	end
end

local function wheelmoved(g,x,y)
	if love.keyboard.isDown('lctrl') then
		g.camera.zoom=g.camera.zoom+y
	else
		g.state.cursor.value=g.state.cursor.value+y
	end
end

local function gamepadpressed(g,button)
	if _G[Enums.games.states.editors[g.state.st]]["gamepadpressed"] then
		_G[Enums.games.states.editors[g.state.st]]["gamepadpressed"](g,button)
	end
end

local function draw(g)
	--LG.print("EDITOR",g.width/2,g.height/2)
	map.draw(g.map)
	cursor.draw(g.state.cursor)
	LG.print("cursor x y "..g.state.cursor.x.." "..g.state.cursor.y,g.width/2,g.height/2+20)
	if _G[Enums.games.states.editors[g.state.st]]["draw"] then
		_G[Enums.games.states.editors[g.state.st]]["draw"](g)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	mousepressed = mousepressed,
	wheelmoved = wheelmoved,
	gamepadpressed = gamepadpressed,
	draw = draw,
}