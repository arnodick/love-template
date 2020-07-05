local keyboard={}
local types={}

keyboard.move = function(a,c)
	local horizontal,vertical=0,0
	local moving=false

	-- print("KEYBOARD MOVE CALLED")
	return types[c.inputtype](a,c,horizontal,vertical,moving)
end

keyboard.action = function()
	local use,action=false,false

	if love.keyboard.isDown('z') then
		use=true
	else
		use=false
	end

	if love.keyboard.isDown('x') then
		action=true
	else
		action=false
	end

	return use,action
end

--vector control can return both horizontal and vertical movement values that != 0, but disallow pressing left and right or up and down
types.vector = function(a,c,horizontal,vertical,moving)
	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		horizontal=-1
		moving=true
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d')  then
		horizontal=1
		moving=true
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		vertical=-1
		moving=true
	elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		vertical=1
		moving=true
	end

	if moving then
		local direction=vector.direction(horizontal,vertical)
		horizontal,vertical=math.cos(direction),math.sin(direction)
	end

	return horizontal,vertical
end

--direct control only allows one direction to be pressed at a time
types.direct = function(a,c,horizontal,vertical,moving)
	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		horizontal=-1
		vertical=0
		moving=true
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d')  then
		horizontal=1
		vertical=0
		moving=true
	elseif love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		horizontal=0
		vertical=-1
		moving=true
	elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		horizontal=0
		vertical=1
		moving=true
	end

	-- if moving and flags.get(a.flags,EF.player) then
	-- 	print("TURN "..Game.turn)
	-- 	print("PLAYER HOR "..horizontal)
	-- 	print("PLAYER VER "..vertical)
	-- end

	return horizontal,vertical
end

return keyboard