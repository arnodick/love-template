local function aim()
	local mx,my=love.mouse.getPosition()
	return mx/(Screen.width/Game.width),my/(Screen.height/Game.height)
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