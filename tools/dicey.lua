local dicey =
{
    _VERSION        = 'diecy v0.01',
    _DESCRIPTION    = 'A collection of dice rolling functions.',
    _LICENSE        = [[
Copyright (c) 2017 Ashley Pringle

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

dicey.roll = function(d,sides,printeach)
	local r=love.math.random(sides)
	table.insert(d,r)
	d.sum=d.sum+r
	d.results[r]=d.results[r]+1
	local s="failed"
	if r>=4 then
		s="succeeded"
		table.insert(d.successes,r)
	else
		table.insert(d.failures, r)
	end
	if printeach then
		print(r.." "..s)
	end
end

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
		dicey.roll(d,sides,printeach)
	end
	print("total successes: "..#d.successes)
	print("total failures:  "..#d.failures)
	print("sum: "..d.sum)
	print("average: "..d.sum/count)
	for i,v in ipairs(d.results) do
		print(i.."s: "..v)
	end
	return d
end

-- Supper:
-- Don't walk for your supper... RUN!

return dicey