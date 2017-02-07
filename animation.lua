local function make(a,speed,frames)
	--sets actor to have an animation
	--speed is how many steps it takes for animation to cycle (higher number is slower animation)
	--frames is how many frames are in the animation
	a.anim={}
	a.anim.speed=speed
	a.anim.frames=frames
end

return
{
	make = make,

}