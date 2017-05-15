local function make(a,t,...)
	local m={}
	--m.t=t

	a[EM[t]]=m
	if _G[EM[t]]["make"] then
		_G[EM[t]]["make"](m,...)
	end
end

return
{
	make = make,
}