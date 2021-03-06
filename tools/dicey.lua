local dicey =
{
    _VERSION        = 'dicey v0.01',
    _DESCRIPTION    = 'A collection of dice rolling functions.',
    _LICENSE        = [[
Copyright (c) 2021 Ashley Pringle

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]
}

--runs the function defined by input args
--t = supper.run(gamename, {"level", "cave", "make"}, ...) will run gamename.level.cave.make(...)
--use this to run different code by varying the input of the string key args
--this means we aren't limited to static functions like gamename.level.cave.make, and so don't need if or switch logic to do something like run game.level.desert.make instead of game.level.cave.make

--rolls an individual die with an amount of faces == sides
dicey.roll = function(sides,printeach)
	local r=love.math.random(sides)
	if printeach then
		print("D"..sides.." roll result: "..r)
	end
	return r
end

--checks if a die roll is equal to or higher than a difficulty number, if so it is a success, if not a failure
--failures and successes are added to counter in the d table
dicey.success = function(d,result,difficulty,printeach)
	local s="failed"
	if result>=difficulty then
		s="succeeded"
		table.insert(d.successes,result)
	else
		table.insert(d.failures, result)
	end
	if printeach then
		print("   "..s)
	end
end

--creates a table d with success, failure, roll sum and result counts, then rolls a number of dice == count
--TODO add difficult input, replace 4 in dicey.success below
dicey.dice = function(sides,count,printeach)
	local d={}
	d.successes={}
	d.failures={}
	d.sum=0
	d.results={}
	for i=1,sides do
		d.results[i]=0
	end

	for i=1,count do
		local r=dicey.roll(sides,printeach)
		--insert dice roll result info into dice pool d
		table.insert(d,r)
		d.sum=d.sum+r--sum of all dice roll results
		d.results[r]=d.results[r]+1--counts of each die roll result (eg if 4 dice had a result of 3 were rolled, d.result[3]==4)
		dicey.success(d,r,4,printeach)
	end

	if printeach then
		print("")
		print("rolled "..count.."D"..sides)
		print("total successes: "..#d.successes)
		print("total failures:  "..#d.failures)
		for i,v in ipairs(d.results) do
			print("   "..i.."s: "..v)
		end
		print("sum: "..d.sum)
		print("average: "..d.sum/count)
	end
	return d
end

--makes a table d with success, failure and roll sum counts, then runs a number dicey.dice sets equal to iterationcount
dicey.iterate = function(iterationcount,sides,count,printeach)
	local d={}
	d.sum=0
	d.successes=0
	d.failures=0

	print("ROLLING "..count.."D"..sides.." "..iterationcount.." TIMES")
	for i=1,iterationcount do
		local r=dicey.dice(sides,count,printeach)
		d.sum=d.sum+r.sum
		d.successes=d.successes+#r.successes
		d.failures=d.failures+#r.failures
	end
	print("AVERAGE ROLL: "..d.sum/(iterationcount*count))
	print("   SUM / (ITERATIONS x ROLLS): "..d.sum.." / ("..iterationcount.." x "..count..")")
	print("SUCCESSES: "..d.successes)
	print("SUCCESSES AVERAGE: "..d.successes/iterationcount)
	print("SUCCESSES AVERAGE ROUNDED: "..math.round(d.successes/iterationcount))
end

-- Dicey:
-- Keep rolling, rolling, rolling, rolling... yeah.

return dicey