local function generate(a,dropname,level)
	a.drop={}
	a.drop.name=dropname
	a.drop.level=level
end

local function make(a,x,y)
	local dropname=a.drop.name
	if dropname then
		local drop=actor.make(EA[dropname],math.floor(x),math.floor(y))
		if a.drop.level then --TODO clean this up
			drop.level=a.drop.level
		end
	end
end

return
{
	generate = generate,
	make = make,
}