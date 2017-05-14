local function make(a,t,...)
	local m={}
	m.t=t

	a[EA.modules[t]]=m
	if _G[EA.modules[t]]["make"] then
		_G[EA.modules[t]]["make"](m,...)
	end
end

return
{
	make = make,
}