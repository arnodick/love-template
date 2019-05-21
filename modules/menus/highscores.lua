local highscores={}

--TODO g this all up
highscores.make = function(m)
	local scoretext={}
	for i,v in ipairs(Game.scores) do
		scoretext[i]=v.name.." "..v.score
	end
	m.text=scoretext
	m.index=0
	module.make(m,EM.border,"dark_purple","indigo")
end

highscores.control = function(g,m)
	function love.textinput(t)
		if m.index==0 then
			for i,v in ipairs(g.scores) do
				if v.name=="" then
					m.index=i
				end
			end
		end
		if m.index~=0 and #g.scores[m.index].name<3 then
			g.scores[m.index].name=g.scores[m.index].name..t
		end
	end
	local scoretext={}
	for i,v in ipairs (g.scores) do
		scoretext[i]=v.name.." "..v.score
	end
	m.text=scoretext
end

return highscores