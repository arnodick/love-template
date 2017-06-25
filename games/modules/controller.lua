local function make(a,cont,t,input,target,y)
	cont[EMC[t]]={}--this gives the controller a table named after the controller's type (ie controller.move)
	local c=cont[EMC[t]]--c is the controller's type sub-table (ie move)
	c.t=t
	c.input=input

	if target then
		if not c.target then--TODO make target into a controller module
			c.target={}
		end
		if type(target)=='table' then
			c.target=target
		else
			c.target.x=target
			c.target.y=y
		end
	end

	if _G[EMC[t]]["make"] then
		_G[EMC[t]]["make"](a,c)
	end
end

local function update(a,gs)
	local c=a.controller
	if c then
		for k,v in pairs(c) do
			local controllername=EMC[v.t]
			if _G[controllername]["control"] then
				local inputname=EI[v.input]
				local command1,command2=_G[inputname][controllername]()
				_G[controllername]["control"](a,v,gs,command1,command2)
			end
		end
	end
end

local function gamepadpressed(a,button)
	local c=a.controller
	if c then
		for k,v in pairs(c) do
			if _G[EMC[v.t]]["gamepadpressed"] then
				_G[EMC[v.t]]["gamepadpressed"](a,v,button)
			end
		end
	end
end

local function deadzone(c,dz)
	local axes={"movehorizontal","movevertical"}
	for i=1,#axes do
		if c[axes[i]]>0 and c[axes[i]]<dz then
			c[axes[i]]=0
		end

		if c[axes[i]]<0 and c[axes[i]]>-dz then
			c[axes[i]]=0
		end
	end
end

return
{
	make = make,
	update = update,
	gamepadpressed = gamepadpressed,
	deadzone = deadzone
}