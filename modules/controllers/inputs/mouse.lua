local function aim(a)--TODO actor in here
	return a.cursor.x,a.cursor.y
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