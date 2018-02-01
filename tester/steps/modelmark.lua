require "cucumber.cucumber"
local wait = require "cucumber.automation.wait"


When("I run a modelmark test with (%d*) instances with scale (.*) using factory (.*) for (.*) frames", function(count, scale, factory_url, frames)
	assert(count)
	assert(scale)
	assert(factory_url)
	assert(frames)
	count = tonumber(count)
	scale = vmath.vector3(tonumber(scale))
	frames = tonumber(frames)

	wait.switch_context(factory_url)

	local root = go.get_id("/root")
	local side = math.ceil(math.pow(count, 1/3))
	local area = math.ceil(side * side)
	for i=1,count do
		local a = i % area
		local x = (a % side) - (side / 2)
		local z = (a / side) - (side / 2)
		local y = (i / area) - (side / 2)
		x = math.random(-side, side)
		y = math.random(-side, side)
		z = math.random(-side, side)
		local id = factory.create(factory_url, vmath.vector3(x, y, z) * 6, nil, {}, scale)
		msg.post(id, "set_parent", { parent_id = root })
	end

	go.animate(root, "euler.y", go.PLAYBACK_LOOP_FORWARD, 360, go.EASING_LINEAR, 12)

	wait.until_true(function(dt)
		frames = frames - 1
		return frames == 0
	end)
end)
