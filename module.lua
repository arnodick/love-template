local function make(a,t,...)
	local m={}
	--m.t=t

	a[Enums.modules[t]]=m
	if _G[Enums.modules[t]]["make"] then
		_G[Enums.modules[t]]["make"](m,...)
	end
end

return
{
	make = make,
}