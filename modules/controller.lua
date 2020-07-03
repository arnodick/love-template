local controller={}

controller.make = function(a,cont,t,input,ai1,ai2)
	local controllertypename=EMC[t]
	cont[controllertypename]={}--this gives the controller a table named after the controller's type (ie controller.move)
	local c=cont[controllertypename]--c is the controller's type sub-table (ie move)
	c.t=t
	c.input=input

	if input==EMCI.gamepad then
		c.id=ai1 or 1
	elseif input==EMCI.keyboard then
		c.inputtype=ai1 or "vector"
		-- c.vector=ai1
	end

	if t==EMC["action"] then
		module.make(c,EM.chance,ai1,ai2)
	else
		module.make(c,EM.target,ai1,ai2)
	end

	run(EMC[t],"make",a,c)
end

controller.update = function(a,gs)
	local c=a.controller

	-- print("CONTROLLER UPDATE")
	if c then
		for k,v in pairs(c) do--this runs all the actor's controllers eg move, action
			local controllertype=EMC[v.t]--controllertype will be "move", "action", etc

			if _G[controllertype]["control"] then
				local inputname=EMCI[v.input]--inputname will be "keyboard", "gamepad" etc
				local command1,command2=_G[inputname][controllertype](a,v)--will run input's type eg keyboard.move, returns commands eg horizontal, vertical movement
				_G[controllertype]["control"](a,v,gs,command1,command2)--will run controller type's control, eg move.control, which sets controller's values eg, c.horizontal = horizontal etc
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