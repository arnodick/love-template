local function make(a,t,...)
	local m={}
	--m.t=t

	if not a[EM[t]] then
		a[EM[t]]=m
	end

	if _G[EM[t]]["make"] then
		_G[EM[t]]["make"](m,...)
	end
end

return
{
	make = make,
}