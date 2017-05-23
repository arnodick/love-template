local function make(a,t,...)
	if not a[EM[t]] then
		a[EM[t]]={}
	end
	
	local m=a[EM[t]]

	if _G[EM[t]]["make"] then
		_G[EM[t]]["make"](a,m,...)
	end
end

return
{
	make = make,
}