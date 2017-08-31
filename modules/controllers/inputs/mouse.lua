local function aim()
	local g=Game
	local mx,my=love.mouse.getPosition()
	return mx/(g.screen.width/g.width),my/(g.screen.height/g.height)
end

local function action()
	local use,action=false,false

	if love.mouse.isDown(1) then
		use=true
	end
	if love.mouse.isDown(2) then
		action=true
	end

	return use,action
end


return
{
	aim = aim,
	action = action,
}