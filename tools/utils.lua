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

local function round(n)
	return math.floor(n+0.5)
end

--GRAPHICS
--draws a box that can be rotated!
local function drawbox(x,y,w,a)
	local circlestuff=0.25*math.pi*2
	for i=0,3 do
		LG.line(x+math.cos(a+i*circlestuff)*w/2,y+math.sin(a+i*circlestuff)*w/2,x+math.cos(a+(i+1)*circlestuff)*w/2,y+math.sin(a+(i+1)*circlestuff)*w/2)
	end
end

--prints text with shadow, different colours, etc.
--TODO needs work
local function printformat(g,text,x,y,limit,align,c1,c2,alpha)
	limit=limit or g.width-x
	align=align or "left"
	alpha=alpha or 1
	for xoff=-1,1 do
		for yoff=-1,1 do
			local r,gr,b=unpack(g.palette[c2])
			LG.setColor(r,gr,b,alpha)--TODO WORK?
			LG.printf(text,x+xoff,y+yoff,limit,align)

			r,gr,b=unpack(g.palette[c1])
			LG.setColor(r,gr,b,alpha)
			LG.printf(text,x,y,limit,align)
		end
	end
	LG.setColor(g.palette["pure_white"])
end

--returns the lightness value of a colour
local function lightness(r,g,b)
	max=math.max(r,g,b)
	min=math.min(r,g,b)
	return (max+min)/2
end

local function floodfill(imgdata,x,y)
	local r,gr,b=imgdata:getPixel(x-1,y-1)
	if love.graphics.coloursame({r,gr,b},{0,0,0}) then
		LG.points(x,y)

		local yd,yu,xl,xr=y+1,y-1,x-1,y+1
		love.graphics.floodfill(imgdata,x,yu)
		-- love.graphics.floodfill(imgdata,x,yd)
		-- love.graphics.floodfill(imgdata,xl,y)
		-- love.graphics.floodfill(imgdata,xr,y)
	end
end

-- Flood-fill (node, target-color, replacement-color):
--  1. If target-color is equal to replacement-color, return.
--  2. ElseIf the color of node is not equal to target-color, return.
--  3. Else Set the color of node to replacement-color.
--  4. Perform Flood-fill (one step to the south of node, target-color, replacement-color).
--     Perform Flood-fill (one step to the north of node, target-color, replacement-color).
--     Perform Flood-fill (one step to the west of node, target-color, replacement-color).
--     Perform Flood-fill (one step to the east of node, target-color, replacement-color).
--  5. Return.

local function coloursame(col1,col2)
	if col1[1]==col2[1] and col1[2]==col2[2] and col1[3]==col2[3] then
		return true
	end
	return false
end

--makes an image in ascii art
local function textify(image,scale,chars,smallcanvas,bigcanvas,charw,charh)
	LG.setCanvas(smallcanvas)
		LG.clear()
		LG.draw(image,0,0,0,scale,scale)
	LG.setCanvas(bigcanvas)
		LG.clear()
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
	LG.setCanvas()
	local mainimgdata=bigcanvas:newImageData()
	return LG.newImage(mainimgdata)
end

--draws an image to the background canvas, which is not refreshed every frame
local function drawtobackground(g,background,drawable,x,y,a,scale,scale,xoff,yoff,alpha)
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
math.round = round
love.graphics.floodfill = floodfill
love.graphics.drawbox = drawbox
love.graphics.printformat = printformat
love.graphics.lightness = lightness
love.graphics.coloursame = coloursame
love.graphics.textify = textify
love.graphics.drawtobackground = drawtobackground
