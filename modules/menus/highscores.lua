local highscores={}

highscores.make = function(m)
	local scoretext={}
	for i=1,#Game.scores.names do
		scoretext[i]=Game.scores.names[i].." "..Game.scores.high[i]
	end
	m.text=scoretext
	m.index=0
	module.make(m,EM.border,EC.dark_purple,EC.indigo)
end

highscores.control = function(m)
	local scoretext={}
	for i=1,#Game.scores.names do
		scoretext[i]=Game.scores.names[i].." "..Game.scores.high[i]
	end
	m.text=scoretext
end

return highscores