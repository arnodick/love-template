local controller={}

--TODO just input g here
controller.make = function(a,cont,t,input,ai1,ai2)
	-- print(a.t)
	local g=Game
	local controllertypename=EMC[t]
	cont[controllertypename]={}--this gives the controller a table named after the controller's type (ie controller.move)
	local c=cont[controllertypename]--c is the controller's type sub-table (ie move)
	c.t=t

	if input==EMCI.gamepad then
		c.id=ai2 or 1
	end

	c.input=input
	--will this put inputtype onto controllers that don't need it? ie ai controllers
	c.inputtype=ai1 or "vector"

	--TODO just do this in game.make as well, but put settings into level, so no _G stuff
	-- if controllertypename=="move" then
	-- 	--TODO do we need ai1 here?
	-- 	--will this put inputtype onto controllers that don't need it? ie ai controllers
	-- 	c.inputtype=ai1 or "vector"

	-- 	--TODO make ai1 _G[g.level.modename].settings input, also put settings into level when making
	-- 	if g then
	-- 		if g.level then
	-- 			local settings=g.level.settings
	-- 			if settings then
	-- 				c.inputtype=settings.inputtype
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- print(c.input)

	--what is this about? is every controller ending up with this?
	if t==EMC["action"] then
		module.make(c,EM.chance,ai1,ai2)
	else
		module.make(c,EM.target,ai1,ai2)
	end

	--TODO do we need EMC here? controllertypename instead
	run(EMC[t],"make",a,c)
end

controller.update = function(a,gs)
	local c=a.controller
	if c then
		for k,v in pairs(c) do--this runs all the actor's controllers eg move, action
			local controllertype=EMC[v.t]--controllertype will be "move", "action", etc
			local ct=_G[controllertype]["control"]

			if ct then
				local inputname=EMCI[v.input]--"keyboard" "gamepad" "ai"
				local command1,command2=_G[inputname][controllertype](a,v)--will run input's type eg keyboard.move, returns commands eg horizontal, vertical movement
				ct(a,v,gs,command1,command2)--will run controller type's control, eg move.control, which sets controller's values eg, c.horizontal = horizontal etc
			end
		end
	end
end

controller.gamepadpressed = function(a,button)
	local c=a.controller
	if c then
		for k,v in pairs(c) do
			if _G[EMC[v.t]]["gamepadpressed"] then
				_G[EMC[v.t]]["gamepadpressed"](a,v,button)
			end
		end
	end
end

controller.deadzone = function(c,dz)
	local l=vector.length(c.horizontal,c.vertical)
	if l<dz then
		c.horizontal=0
		c.vertical=0
	end
--[[
	local axes={"horizontal","vertical"}
	for i=1,#axes do
		if c[axes[i] ]>0 and c[axes[i] ]<dz then
			c[axes[i] ]=0
		end

		if c[axes[i] ]<0 and c[axes[i] ]>-dz then
			c[axes[i] ]=0
		end
	end
--]]
end

return controller