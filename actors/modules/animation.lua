local function make(a,anim,speed,frames)
	--sets actor to have an animation
	--speed is how many steps it takes for animation to cycle (higher number is slower animation)
	--frames is how many frames are in the animation
	anim.speed=speed
	anim.frames=frames
end

return
{
	make = make,

}