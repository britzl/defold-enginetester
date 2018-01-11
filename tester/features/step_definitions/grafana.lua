require "cucumber.cucumber"
local wait = require "cucumber.automation.wait"



local function random_pos()
	local x = math.random(640)
	local y = math.random(1136)
	return vmath.vector3(x, y, 0)
end


When("I run a stress test with (%d*) instances using factory (.*) for (.*) seconds", function(count, factory_url, duration)
	assert(count)
	assert(factory_url)
	assert(duration)
	local ids = {}
	count = tonumber(count)
	duration = tonumber(duration)
	wait.until_true(function(dt)
		wait.switch_context(factory_url)
		while #ids > 0 do
			local id = table.remove(ids, 1)
			go.delete(id)
		end

		for i=1,count do
			local id = factory.create(factory_url, random_pos())
			ids[#ids + 1] = id
		end
		duration = duration - dt
		return duration <= 0
	end)
end)
