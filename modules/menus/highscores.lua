local highscores={}

highscores.make = function(m)
	local scoretext={}
	for i=1,#Game.scores.names do
		scoretext[i]=Game.scores.names[i].." "..Game.scores.high[i]
	end
	m.text=scoretext
	m.index=0
	-- module.make(m,EM.border,EC.dark_purple,EC.indigo)
	module.make(m,EM.border,"dark_purple","indigo")
end

highscores.control = function(g,m)
	function love.textinput(t)
		if m.index==0 then
			for i=1,#g.scores.names do
				if g.scores.names[i]=="" then
					m.index=i
				end
			end
		end
		if m.index~=0 and #g.scores.names[m.index]<3 then
			g.scores.names[m.index]=g.scores.names[m.index]..t
		end
	end
	local scoretext={}
	for i=1,#g.scores.names do
		scoretext[i]=g.scores.names[i].." "..g.scores.high[i]
	end
	m.text=scoretext
end

return highscores