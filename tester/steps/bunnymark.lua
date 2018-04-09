require "cucumber.cucumber"
local wait = require "cucumber.automation.wait"

local BUNNY_IMAGES = {
	hash("rabbitv3_batman"),
	hash("rabbitv3_bb8"),
	hash("rabbitv3"),
	hash("rabbitv3_ash"),
	hash("rabbitv3_frankenstein"),
	hash("rabbitv3_neo"),
	hash("rabbitv3_sonic"),
	hash("rabbitv3_spidey"),
	hash("rabbitv3_stormtrooper"),
	hash("rabbitv3_superman"),
	hash("rabbitv3_tron"),
	hash("rabbitv3_wolverine"),
}

local function random_pos()
	local x = math.random(640)
	local y = 1030
	return vmath.vector3(x, y, 0)
end

local function spawn_bunny(factory_url)
	local id = factory.create(factory_url)
	msg.post(msg.url(nil, id, "sprite"), "play_animation", { id = BUNNY_IMAGES[math.random(1, #BUNNY_IMAGES)] })
	return id
end

local function animate_bunny(id)
	go.set_position(random_pos(), id)
	go.animate(id, "position.y", go.PLAYBACK_LOOP_PINGPONG, 40, go.EASING_INQUAD, 2, math.random())
end

When("I run a bunnymark test with (%d*) instances using factory (.*) for (.*) frames", function(count, factory_url, frames)
	assert(count)
	assert(factory_url)
	assert(frames)
	count = tonumber(count)
	frames = tonumber(frames)

	wait.switch_context(factory_url)
	for i=1,count do
		animate_bunny(spawn_bunny(factory_url))
	end

	wait.until_true(function(dt)
		frames = frames - 1
		return frames == 0
	end, (frames * 10 / 60))
	assert(frames == 0)
end)
