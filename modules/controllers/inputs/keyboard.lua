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

--TODO implement these! when create keyboard controller default to above style, otherwise use types below
types.vector = function(a,c,horizontal,vertical,moving)
	-- local horizontal,vertical=0,0
	-- local moving=false

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

	-- if c.vector then
		if moving then
			local direction=vector.direction(horizontal,vertical)
			horizontal,vertical=math.cos(direction),math.sin(direction)
		end
	-- end

	return horizontal,vertical
end

types.direct = function(a,c,horizontal,vertical,moving)
	-- local horizontal,vertical=0,0
	-- local moving=false

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		if a.controller.move.last.horizontal==0 then
			horizontal=-1
			vertical=0
			moving=true
		end
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d')  then
		if a.controller.move.last.horizontal==0 then
			horizontal=1
			vertical=0
			moving=true
		end
	elseif love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		if a.controller.move.last.vertical==0 then
			horizontal=0
			vertical=-1
			moving=true
		end
	elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		if a.controller.move.last.vertical==0 then
			horizontal=0
			vertical=1
			moving=true
		end
	end

	if moving then
	print("HOR "..horizontal)
	print("VER "..vertical)
	end

	return horizontal,vertical
end

return keyboard