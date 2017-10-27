local function make(g)
	--g.state.mode=Enums.games.modes.isometric
	--g.state.modename=Enums.games.modes[g.state.mode]

	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	g.map=map.generate({"random","walls"},mw,mh,{pool={1,1,1,1,2,3,4}})
	--g.map=map.generate({"random"},mw,mh,{pool={1,1,1,1,2,3,4}})

	--g.step=false

	g.player=actor.make(EA[g.name].iso_player,g.width/2,g.height/2)
	--actor.make(EA[Game.name].rpg_enemy,g.width/2,g.height/2)

	g.camera.x=50
	g.camera.y=100
end

local function control(g)
	--Game.pause=true
end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	elseif key=='space' then
		local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		g.timer=0
		g.map=map.generate("random",mw,mh,{pool={1,1,1,1,2,3,4}})
	end

	local ease=easing.outElastic
	local dist=300
	local d=300
	if key=='right' then
		module.make(g.camera,EM.transition,ease,"x",g.camera.x,dist,d)
	elseif key=='left' then
		module.make(g.camera,EM.transition,ease,"x",g.camera.x,-dist,d)
	elseif key=='up' then
		module.make(g.camera,EM.transition,ease,"y",g.camera.y,-dist,d)
	elseif key=='down' then
		module.make(g.camera,EM.transition,ease,"y",g.camera.y,dist,d)
	end

	if key=='z' then
		module.make(g.camera,EM.transition,ease,"zoom",g.camera.zoom,4,d)
	elseif key=='x' then
		module.make(g.camera,EM.transition,ease,"zoom",g.camera.zoom,-4,d)
	end
end

local function gamepadpressed(g,button)

end

local function draw(g)
	map.draw(g.map,"isometric")--TODO make isometric levels so this draw doesn't go over the actors
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}