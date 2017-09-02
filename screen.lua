local function update(g)
	local s={}
	local gw,gh=g.width,g.height
	s.width,s.height=LG.getDimensions()
	s.scale=math.floor(s.height/gh)
	s.xoff=(s.width-gw*s.scale)/2
	s.yoff=s.height%gh/2
--[[
	if s.width>=s.height then
		s.scale=math.floor(s.height/gh)
		s.xoff=(s.width-gw*s.scale)/2
		s.yoff=s.height%gh/2
	else
		s.scale=math.floor(s.width/gw)
		s.xoff=(s.height-gh*s.scale)/2
		s.yoff=s.width%gw/2
	end
--]]
	s.pixelscale=1
	s.shake=0

	s.font=LG.newFont("fonts/Kongtext Regular.ttf",8)
	LG.setFont(s.font)

	g.screen=s
end

local function control(g,s,gs)
	if s.shake>0 then
		s.shake = s.shake - gs
	end

	if _G[Enums.games.screens[g.st]]["control"] then
		_G[Enums.games.screens[g.st]]["control"](g,s)
	end
end

return
{
	update = update,
	control = control,
}