local inventory={}

inventory.make = function(g,a,m,size)
	m.i=1
	m.max=size or 1
end

inventory.control = function(a,inv)
	for i,v in ipairs(inv) do
		item.carry(v,a)
	end
end

inventory.dead = function(a,inv)
	if inv then
		for i,v in ipairs(inv) do
			item.drop(v,a)
		end
	end
end

return inventory