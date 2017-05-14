local function make(a,t,...)
	local m={}
	m.t=t

	a[EA.modules[t]]=m
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
	make = make,
	control = control,
	draw = draw,
}