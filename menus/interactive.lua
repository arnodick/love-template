local function make(m,buttons,args)
	m.buttons=buttons
	m.args=args
	m.text.index=1
	controller.make(m,ECT.move,ECT.moves.gamepad_move)
	m.controller.move.last=0
end

local function control(m)
	--if m.controller then
		controller.update(m)
	--end
	if m.controller.move.movevertical<0 then
		if m.controller.move.last>=0 then
			m.text.index=math.clamp(m.text.index-1,1,#m.text,true)
		end
	elseif m.controller.move.movevertical>0 then
		if m.controller.move.last<=0 then
			m.text.index=math.clamp(m.text.index+1,1,#m.text,true)
		end
	end
	if Joysticks[1]:isDown(1) then--TODO make this done by a controller
		local i=m.text.index
		if m.buttons[i] then
			m.buttons[i](unpack(m.args[i]))
		end
	end
	m.controller.move.last=m.controller.move.movevertical
end

local function draw(m)
end

return
{
	make = make,
	control = control,
	draw = draw,
}