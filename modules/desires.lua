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
					module.make(a,EM.controller,EMC.move,EMCI.ai,item)
					module.make(a,EM.controller,EMC.action,EMCI.ai,0.01,0)
				elseif m.queue[1]=="kill" then
					local person=supper.random(g.actors.persons)
					module.make(a,EM.controller,EMC.move,EMCI.ai,person)
					module.make(a,EM.controller,EMC.action,EMCI.ai,0.01,0)
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
			--TODO item.pickup here?
			if actor.collision(t.x,t.y,a) then
				if t.sound then
					if t.sound.get then
						sfx.play(t.sound.get)
					end
				end
				t.flags=flags.set(t.flags,EF.persistent)
				table.insert(a.inventory,1,t)
				local person=supper.random(Game.actors.persons)
				module.make(a,EM.controller,EMC.aim,EMCI.ai,person)
			end
		end
	end
end

return desires