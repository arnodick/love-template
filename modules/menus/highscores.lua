local function make(m)
	local scoretext={}
	for i=1,#Game.scores.names do
		scoretext[i]=Game.scores.names[i].." "..Game.scores.high[i]
	end
	m.text=scoretext
	module.make(m,EM.border,EC.dark_purple,EC.indigo)
end

local function control(m)

end

local function draw(m)

end

return
{
	make = make,
	control = control,
	draw = draw,
}