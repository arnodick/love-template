local function generate(a,t,...)

end

local function make(a,t,...)
	local m={}
	m.t=t

	if not a.modules then
		a.modules={}
	end

	a.modules[EA.modules[t]]=m
	if _G[EA.modules[t]]["make"] then
		_G[EA.modules[t]]["make"](a,m,...)
	end
end

local function control(a,t,...)
	if _G[EA.modules[t]]["control"] then
		_G[EA.modules[t]]["control"](a,...)
	end
end

local function draw(a,t,...)
	if _G[EA.modules[t]]["draw"] then
		_G[EA.modules[t]]["draw"](a,...)
	end
end

return
{
	generate = generate,
	make = make,
	control = control,
	draw = draw,
}