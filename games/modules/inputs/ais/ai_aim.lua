local function move()
	return 	j:getGamepadAxis("leftx"), j:getGamepadAxis("lefty")
end

local function aim(a,c)
	local hor,ver=0,0
	--print(c.target)
	--print(Player)
	local dir=vector.direction(vector.components(a.x,a.y,c.target.x,c.target.y))
	--local dir=vector.direction(vector.components(a.x,a.y,Player.x,Player.y))
	hor=math.cos(dir)
	ver=math.sin(dir)
	return 	hor,ver
end

local function action()
	local use=false
	local action=false

	if j:isDown(3) or j:getGamepadAxis("triggerright")>0 then
		use=true
	end

	if j:isDown(1) or j:getGamepadAxis("triggerleft")>0 then
		action=true
	end

	return 	use, action
end


return
{
	move = move,
	aim = aim,
	action = action,
}