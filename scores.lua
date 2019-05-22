local scores={}

--TODO take g in, has settings for amount of scores etc
--TODO score.make? makes a {"name",score} table
scores.load = function()
	local s={}
	if not love.filesystem.exists("scores.json") then	
		for i=1,8 do
			table.insert(s,{name="ASH",score=love.math.random(10)})
		end
		scores.sort(s)
		json.save("scores.json",s)
	else
		s=json.load("scores.json")
	end
	return s
end

scores.sort = function(s,descending)
	descending=descending or false
	local function scoresort(a,b)
		if a.score<=b.score then
			return descending
		elseif a.score>b.score then
			return not descending
		end
	end
	table.sort(s,scoresort)
end

--TODO input g here
scores.update = function()
	local s=scores.load()

	table.insert(s,{name="",score=Game.score})

	scores.sort(s)

	for i=#s,1,-1 do
		if i>8 then--TODO make this get its input from g.score or something
			table.remove(s,i)
		end
	end
	Game.scores=s
end

scores.save = function()
	for i,v in ipairs(Game.scores) do
		if v.name=="" then
			v.name="X"
		end
	end
	json.save("scores.json",Game.scores)
end

return scores