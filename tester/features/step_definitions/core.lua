local wait = require "tester.utils.wait"
local metrics = require "tester.utils.metrics"


local errors = {}

local _pcall = pcall
local _xpcall = xpcall

Before(function()
	errors = {}
	_pcall = pcall
	_xpcall = xpcall
end)

After(function()
	pcall = _pcall
	xpcall = _xpcall
	metrics.stop()
end)

Given("the (.*) collection is loaded", function(proxy_url)
	wait.load_proxy(proxy_url)
end)

Given("error checking is enabled", function()
	pcall = function(f, ...)
		local success, err = _pcall(f, ...)
		if not success then
			table.insert(errors, { message = err, traceback = debug.traceback() })
		end
		return true
	end
	--[[sys.set_error_handler(function(source, message, traceback)
		table.insert(errors, { source = source, message = message, traceback = traceback })
	end)--]]
end)

Given("fps metrics is collected with a (%d*) second interval", function(interval)
	metrics.collect(metrics.FPS, tonumber(interval))
end)

Given("cpu metrics is collected with a (%d*) second interval", function(interval)
	metrics.collect(metrics.CPU, tonumber(interval))
end)

Given("mem metrics is collected with a (%d*) second interval", function(interval)
	metrics.collect(metrics.MEM, tonumber(interval))
end)

local function compare_first_last_sample(samples)
	local first = samples[1]
	local last = samples[#samples]
	local diff = first - last
	--pprint(samples)
	--print("first", first, "last", last, "diff", diff, "first*0.1", first * 0.1)
	return diff <= first * 0.1, diff
end

Then("fps metrics should not deteriorate over time", function()
	local ok, diff = compare_first_last_sample(metrics.samples(metrics.FPS))
	assert(ok, ("FPS metrics differs by (%d)"):format(diff))
end)

Then("cpu metrics should not deteriorate over time", function()
	local ok, diff = compare_first_last_sample(metrics.samples(metrics.CPU))
	assert(ok, ("CPU metrics differs by (%d)"):format(diff))
end)

Then("mem metrics should not deteriorate over time", function()
	local ok, diff = compare_first_last_sample(metrics.samples(metrics.MEM))
	assert(ok, ("MEM metrics differs by (%d)"):format(diff))
end)

When("I wait (.*) seconds?", function(seconds)
	wait.seconds(tonumber(seconds))
end)

Then("an error should have happened", function()
	assert(#errors > 0, "Expected an error")
end)
