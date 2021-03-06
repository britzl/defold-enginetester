require "cucumber.cucumber"
local metrics = require "tester.utils.metrics"

local function is_deteriorating(samples, max_diff_percent)
	local count = math.ceil(#samples / 10)
	local first = 0
	for i=1,count do
		first = first + samples[i]
	end
	first = first / count

	local last = 0
	for i=#samples-count+1,#samples do
		last = last + samples[i]
	end
	last = last / count
	local diff = first - last
	return diff <= 0 or first * (max_diff_percent or 0.10) >= last, diff
end


After(function()
	metrics.stop()
end)

Given("fps metrics are collected with a (%d*) second interval", function(interval)
	metrics.collect(metrics.FPS, metrics.time_interval(tonumber(interval)))
end)

Given("frame time metrics are collected with a (%d*) frame interval", function(interval)
	metrics.collect(metrics.FRAMETIME, metrics.frame_interval(tonumber(interval)))
end)

Given("frame time metrics are collected every frame", function()
	metrics.collect(metrics.FRAMETIME, metrics.frame_interval(0))
end)

Given("cpu metrics are collected with a (%d*) second interval", function(interval)
	metrics.collect(metrics.CPU, metrics.time_interval(tonumber(interval)))
end)

Given("mem metrics are collected with a (%d*) second interval", function(interval)
	metrics.collect(metrics.MEM, metrics.time_interval(tonumber(interval)))
end)

Then("fps metrics should not deteriorate over time", function()
	local ok, diff = is_deteriorating(metrics.samples(metrics.FPS))
	assert(ok, ("FPS metrics differs by (%d)"):format(diff))
end)

Then("cpu metrics should not deteriorate over time", function()
	local ok, diff = is_deteriorating(metrics.samples(metrics.CPU))
	assert(ok, ("CPU metrics differs by (%f)"):format(diff, 0.2))
end)

Then("mem metrics should not deteriorate over time", function()
	local ok, diff = is_deteriorating(metrics.samples(metrics.MEM))
	assert(ok, ("MEM metrics differs by (%d)"):format(diff))
end)

Then("aggregated frame time should be less than (%d*) seconds", function(max)
	max = tonumber(max)
	local actual = metrics.total(metrics.FRAMETIME)
	assert(actual < max, ("Aggregated FRAMETIME expected to be less than %f but was %f"):format(max, actual))
end)

Then("average frame time should be less than (.*) seconds", function(expected)
	expected = tonumber(expected)
	local actual = metrics.average(metrics.FRAMETIME)
	assert(actual <= expected, ("Average FRAMETIME expected to be less than %f but was %f"):format(expected, actual))
end)
