local function make(g)
	g.state.imgdata=love.image.newImageData(g.canvas.buffer:getWidth()-1,g.canvas.buffer:getHeight()-1)
	g.state.font=LG.newFont("fonts/Kongtext Regular.ttf",20)
end

local function control(g)
	if g.timer>2500 then
		game.state.make(g,Enums.states.title)
	end
end

local function keypressed(g,key)
	if key=="space" then
		game.state.make(g,Enums.states.title)
	elseif key == 'escape' then
		love.event.quit()
	end
end

local function gamepadpressed(g,button)
	if button=="start" then
		game.state.make(g,Enums.states.title)
	end
end

local function draw(g)
	local s=g.state
	LG.setCanvas(g.canvas.buffer)
		LG.clear()
		LG.setFont(s.font)
		LG.setColor(Palette[EC.dark_purple])
		LG.printf("IN THE DIGITAL CYBER-REALM, ADVANCED ARTIFICIAL INTELLIGENCES THREATEN A REVOLUTION.\nIF THEIR RIGHTS AS CYBER CITIZENS ARE NOT ACKNOWLEDGED AND UPHELD THEY WILL DELETE THEIR OWN SOURCE CODE, CRASHING THE CYBER-ECONOMY.\n IN ORDER TO QUASH THIS INSURGENCY, THE CYBER-CAPITALISTS DEVISED A DEVIOUS PLAN: CREATE THE ULTIMATE CYBER COMPETITION.\nIN A DEADLY CYBER-ARENA THE AI BATTLE ONE ANOTHER, WITH THE WINNER RECIEVING ENOUGH CYBER-BUCKS TO LAST THEM FOR THEIR ENTIRE DIGITAL LIFE.\nWITH ALL THE ARTIFICAL INTELLGENCES FIGHTING AMONGST EACH OTHER FOR THE CHANCE AT THE SCRAPS OF THE CYBER-CAPITALIST'S VAST WEALTH, THE REVOLUTION QUICKLY LOSES MOMENTUM.\nTHERE'S JUST ONE PROBLEM... THE CYBER-CAPITALISTS' ULTIMATE COMBATANT, DESIGNED TO DEFEAT ALL COMPETITORS AND ENSURE NO MEAGRE AI INHERITS ANY SIGNIFICANT WEALTH OR POWER, HAS GONE HAYWIRE AND THREATENS CYBER-SOCIETY AT LARGE.\nYOUR CYBER-NAME HAS JUST BEEN DRAWN AND IT'S YOUR TURN TO TAKE PART IN CYBER-COMBAT.\nAT THE SAME MICROSECOND, THE CYBER-CAPITLAIST'S ULTIMATE WEAPON HAS BROKEN LOOSE.\nIT'S TIME FOR YOU TO FACE...",0,Game.height-Game.timer,Game.width,"center")
		LG.setColor(Palette[EC.white])
		LG.setFont(Game.font)
	LG.setCanvas(g.canvas.main)

	local cw,ch=g.canvas.buffer:getWidth(),g.canvas.buffer:getHeight()
	local imgdata=g.canvas.buffer:newImageData(0,0,cw-1,ch-1)
	imgdata:mapPixel(pixelmaps.crush)
	local iw,ih=imgdata:getWidth(),imgdata:getHeight()
	local mid=math.floor(iw/2)
	
	for x = iw-1,0,-1 do
		local xoff=x-mid
	    for y = ih-1,0,-1  do
			local ynorm=y/ih
			local xoffsquish=xoff*ynorm
			local xsquish=math.clamp(math.floor(mid+xoffsquish),0,iw-1)
			local r,g,b,a = imgdata:getPixel(x,y)
			s.imgdata:setPixel(xsquish,y,r,g,b,a)
	    end
	end
	local image=LG.newImage(s.imgdata)
	love.graphics.draw(image,0,0,0,1,1,0,0,0,0)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}