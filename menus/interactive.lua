local function make(m)
	m.text.index=1
	controller.make(m,ECT.move,ECT.moves.gamepad_move)
	m.controller.last=0
end

local function control(m)
	if m.controller.move.movevertical<0 then
		if m.controller.last>=0 then
			m.text.index=math.clamp(m.text.index-1,1,#m.text,true)
		end
	elseif m.controller.move.movevertical>0 then
		if m.controller.last<=0 then
			m.text.index=math.clamp(m.text.index+1,1,#m.text,true)
		end
	end
	m.controller.last=m.controller.move.movevertical
end

local function draw(m)
	print(m.controller.move.movevertical)
end

return
{
	make = make,
	control = control,
	draw = draw,
}