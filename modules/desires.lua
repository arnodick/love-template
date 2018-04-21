local desires={}

desires.make = function(a,m,pool)
	m.pool=pool
	m.queue={}
	for i=1,10 do
		table.insert(m.queue,supper.random(pool))
	end
end

desires.control = function(a,m)
	if not a.controller then
		local g=Game
		if #m.queue>0 then
			if g.players[1] then
				if m.queue[1]=="item" then
					local item=supper.random(g.actors.items)
					local dir=vector.direction(vector.components(a.x,a.y,item.x,item.y))
					local dist=vector.distance(a.x,a.y,item.x,item.y)
					local r=ray.cast(a.x,a.y,dir,dist,1)
					a.blocked=false
					if r.len<dist then
						a.blocked=true
					end
					module.make(a,EM.controller,EMC.move,EMCI.ai,item)
					module.make(a,EM.controller,EMC.action,EMCI.ai,0.01,1)
					module.make(a,EM.controller,EMC.aim,EMCI.ai,item)
				elseif m.queue[1]=="kill" then
					local person=supper.random(g.actors.persons)
					while person==a do
						person=supper.random(g.actors.persons)
					end
					module.make(a,EM.controller,EMC.move,EMCI.ai,person)
					module.make(a,EM.controller,EMC.action,EMCI.ai,0.01,0)
					module.make(a,EM.controller,EMC.aim,EMCI.ai,person)
				end
			end
		else
			for i=1,10 do
				table.insert(m.queue,supper.random(m.pool))
			end
		end
	else
		local t=a.controller.move.target
		if t.item then
			local pickedup=item.pickup(t,a)
			--local person=supper.random(Game.actors.persons)
			--module.make(a,EM.controller,EMC.aim,EMCI.ai,person)
			if pickedup then
				for i=#m.queue,1,-1 do
					if m.queue[i]=="item" then
						table.remove(m.queue,i)
					end
				end
				a.controller=nil
			end
		end
	end
end

return desires