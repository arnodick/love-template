--MATH
--clamps a value between a min and max inclusive, with an option to wrap from max to min or vice versa
local function clamp(v,min,max,wrap)--TODO recursive clamp (what does this mean again?)
	wrap=wrap or false
	if not wrap then--if no wrapping, then hard clamp to min or max limit
		if v<min then v=min
		elseif v>max then v=max
		end
	else
		if v<min then v=max+1+v-min--not sure what is going on here?
		elseif v>max then v=min-1+v-max
		end
	end
	return v
end

--choose one value from an input of any amount of args
local function choose(...)
	local args={...}--make a table from all the args
	return args[love.math.random(#args)]--choose one arg at random
end

--takes number n, returns a fraction greater than 0 but less than or equal to n
--ie: n = 4 may give results like 0.1 or 3.9, but not 0 or 4.1
local function randomfraction(n,d)
	d=d or 1000000
	return love.math.random(n*d)/d--get a random integer from 1 to 4000000 if n = 4 and d = 1000000, then divide that by d to get a fraction
end

--snaps a value v to a target value if the difference between v and snapto is greater than inc
local function snap(v,inc,snapto)--TODO does this need a negative version
	if v-inc<=snapto+inc then--TODO make this addition instead of subtraction?
		return snapto
	else
		return v-inc
	end
end

--GRAPHICS
--draws a box that can be rotated!
local function drawbox(x,y,w,a)
	for i=0,3 do
		LG.line(x+math.cos(a+i*0.25*math.pi*2)*w/2,y+math.sin(a+i*0.25*math.pi*2)*w/2,x+math.cos(a+(i+1)*0.25*math.pi*2)*w/2,y+math.sin(a+(i+1)*0.25*math.pi*2)*w/2)
	end
end

--prints text with shadow, different colours, etc.
--TODO needs work
local function printformat(text,x,y,limit,align,c1,c2,alpha)
	limit=limit or Game.width-x
	align=align or "left"
	alpha=alpha or 1
	for xoff=-1,1 do
		for yoff=1,1 do
			local r,g,b=unpack(Game.palette[c2])
			LG.setColor(r,g,b,alpha)
			LG.printf(text,x+xoff*2,y+yoff*2,limit,align)

			r,g,b=unpack(Game.palette[c1])
			LG.setColor(r,g,b,alpha)
			LG.printf(text,x,y,limit,align)
		end
	end
	LG.setColor(Game.palette["pure_white"])
end

--returns the lightness value of a colour
local function lightness(r,g,b)
	r,g,b=r/255,g/255,b/255
	max=math.max(r,g,b)
	min=math.min(r,g,b)
	return (max+min)/2
end

--makes an image in ascii art
local function textify(image,scale,chars,smallcanvas,bigcanvas,charw,charh)
	--local g=Game
	LG.setCanvas(smallcanvas)
		LG.clear()
		LG.draw(image,0,0,0,scale,scale)
	LG.setCanvas(bigcanvas)
		LG.clear()
		-- local imgdata=smallcanvas:newImageData(0,0,smallcanvas:getWidth(),smallcanvas:getHeight())
		local imgdata=smallcanvas:newImageData()
		for y=0,imgdata:getWidth()-1 do
			for x=0,imgdata:getHeight()-1 do
				local r,gr,b=imgdata:getPixel(x,y)
				local l=LG.lightness(r,gr,b)
				l=math.ceil(l*10)
				LG.setColor(r,gr,b)
				LG.print(chars[l+1],x*charw,y*charh)
			end
		end
		LG.setColor(1,1,1) --sets draw colour back to normal
		-- local mainimgdata=bigcanvas:newImageData(0,0,bigcanvas:getWidth(),bigcanvas:getHeight())
	LG.setCanvas()
	local mainimgdata=bigcanvas:newImageData()
	return LG.newImage(mainimgdata)
end

--draws an image to the background canvas, which is not refreshed every frame
--TODO needs work, take g as input?
local function drawtobackground(background,drawable,x,y,a,scale,scale,xoff,yoff,alpha)
	local g=Game
	local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
	LG.setCanvas(background)
		if alpha then
			-- LG.setColor(255,255,255,alpha)
			LG.setColor(1,1,1,alpha)
		end
		LG.draw(drawable,x+xcamoff,y+ycamoff,a,scale,scale,xoff,yoff)
	LG.setCanvas(g.canvas.main)
end

math.clamp = clamp
math.choose = choose
math.randomfraction = randomfraction
math.snap = snap
love.graphics.drawbox = drawbox
love.graphics.printformat = printformat
love.graphics.lightness = lightness
love.graphics.textify = textify
love.graphics.drawtobackground = drawtobackground
