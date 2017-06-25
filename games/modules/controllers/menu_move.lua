local function control(a,c)
	local i=a.input.move
	
	c.movehorizontal=i.horizontal
	c.movevertical=i.vertical

	local axes={"movehorizontal","movevertical"}
	for i=1,#axes do
		if c[axes[i]]>0 and c[axes[i]]<deadzone then
			c[axes[i]]=0
		end

		if c[axes[i]]<0 and c[axes[i]]>-deadzone then
			c[axes[i]]=0
		end
	end

	if c.movevertical<0 then
		if c.lastvertical>=0 then
			a.text.index=math.clamp(a.text.index-1,1,#a.text,true)
		end
	elseif c.movevertical>0 then
		if c.lastvertical<=0 then
			a.text.index=math.clamp(a.text.index+1,1,#a.text,true)
		end
	end
end

return
{
	control = control,
}