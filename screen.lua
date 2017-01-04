local function update(gw,gh)
	local s={}
	s.width,s.height=love.graphics.getDimensions()
	s.scale=math.floor(s.height/gh)
	s.xoff=(s.width-gw*s.scale)/2
	s.yoff=s.height%gh/2
	return s
end

return
{
	update = update,
}